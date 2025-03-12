import { Account, TokenSet, Profile, User, Awaitable } from "@auth/core/types"
import { ApolloClient, InMemoryCache, gql } from "@apollo/client";
import { ProfileCallback, UserinfoEndpointHandler } from "next-auth/providers";
import NextAuth, { Session, type DefaultSession } from "next-auth";
import type { JWT } from "next-auth/jwt";

// Defining some known URLs. In a real application, these would be environment variables.
const apiRootUrl = "http://localhost:3000";
const authorizationUrl = `${apiRootUrl}/oauth/authorize`;
const tokenUrl = `${apiRootUrl}/oauth/token`;
const graphqlUrl = `${apiRootUrl}/graphql`;

// Here we extend next-auth types.
declare module "next-auth" {
  interface Session {
    user: {
      id: string;
      email: string;
    } & DefaultSession["user"];
    accessToken: string;
  }
}

declare module "next-auth/jwt" {
  interface JWT {
    accessToken: string;
    accessTokenExpires: number;
    refreshToken?: string;
  }
}

async function authenticatedClient(accessToken?: string) {
  if (!accessToken) {
    const session = await auth();
    accessToken = session?.accessToken;
  }

  console.log("authenticatedClient", { accessToken });

  return new ApolloClient({
    cache: new InMemoryCache(),
    uri: graphqlUrl,
    headers: accessToken ? { Authorization: `Bearer ${accessToken}` } : {},
  });
}

// Called when the authenticated user needs to refresh their access token.
export async function refreshAccessToken(token: JWT) {
  try {
    const response = await fetch(tokenUrl, {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({
        grant_type: "refresh_token",
        refresh_token: token.refreshToken as string,
        client_id: process.env.AUTH_LEDGER_API_ID as string,
        client_secret: process.env.AUTH_LEDGER_API_SECRET as string,
      })
    });

    const refreshedTokens = await response.json();

    return {
      ...token,
      accessToken: refreshedTokens.access_token,
      accessTokenExpires: Date.now() + (refreshedTokens.expires_in || 0) * 1000,
      refreshToken: refreshedTokens.refresh_token ?? token.refreshToken, // Fall back to old refresh token
    }
  } catch(error) {
    console.error("Error refreshing access token", error);
    return {
      ...token,
      error: "RefreshAccessTokenError",
    }
  }
}

// Called immediately after signing in to fetch user information.
// Here we provide a custom function that uses the GraphQL API to fetch user info.
export const userInfoCallback: UserinfoEndpointHandler = async ({ tokens }: { tokens: TokenSet }) => {
  const query = gql`{ viewer { id email } }`;
  const client = await authenticatedClient(tokens.access_token);

  try {
    const response = await client.query({ query, fetchPolicy: "network-only" });
    const { viewer: { id, email } } = response.data;
    return {
      id: id ?? undefined,
      email: email ?? undefined
    }
  } catch(error) {
    return {};
  }
}

// Callback used by Auth.js to transform the profile object.
export const profileCallback: ProfileCallback<Profile> = (profile: Profile) => {
  return profile as User;
}

// Callback used by Auth.js to handle JWT token changes.
export const jwtCallback: (params: { token: JWT, account: Account | null }) => Awaitable<JWT> = async ({ token, account }) => {
  if (account && account.access_token) {
    token.id = account.providerAccountId;
    token.accessToken = account.access_token;
    token.refreshToken = account.refresh_token;
    token.accessTokenExpires = Date.now() + (account.expires_in || 0) * 1000;
    return token;
  }

  if (Date.now() < token.accessTokenExpires) {
    return token;
  }

  return refreshAccessToken(token);
}

// Callback used by Auth.js to handle session changes.
export const sessionCallback: (params: { session: Session, token: JWT }) => Awaitable<Session> = async ({ session, token }) =>  {
  if (token) {
    session.user.id = token.id as string;
    session.accessToken = token.accessToken as string;
  }

  return session;
}

// Initialize NextAuth with the defined providers and callbacks.
// This is the main entrypoint the configuration of NextAuth.
//
// NOTE: In a real application, you would need to replace the clientId and clientSecret with your actual credentials,
// and never include real credentials here in the source code. Auth.js uses environment variables by default for security.
export const { auth, handlers, signIn, signOut } = NextAuth({
  secret: "fake-auth-secret",
  providers: [{
    id: "ledger_api",
    name: "The Ledger",
    type: "oauth",
    clientId: "ledger-client-id",
    clientSecret: "ledger-client-secret",
    authorization: {
      url: authorizationUrl,
      params: { scope: "read write" }
    },
    token: { url: tokenUrl },
    userinfo: { url: graphqlUrl, request: userInfoCallback },
    profile: profileCallback,
  }],
  callbacks: {
    jwt: jwtCallback,
    session: sessionCallback,
    async authorized({ auth }) {
      return !!auth;
    }
  },
  pages: {
    signIn: "/"
  }
});