import { HttpLink } from "@apollo/client";
import { registerApolloClient, ApolloClient, InMemoryCache } from "@apollo/experimental-nextjs-app-support";
import { auth } from "@/auth";

// This is the main entry point for setting up Apollo Client in a Next.js application.
// The new experimental nextjs support allows for a shared graphql client for the same
// request to correctly pass down data to components for hydration.
export const { getClient, query, PreloadQuery } = registerApolloClient(async () => {
  const session = await auth();

  return new ApolloClient({
    cache: new InMemoryCache(),
    link: new HttpLink({
      uri: "http://localhost:3000/graphql",
      headers: {
        Authorization: session?.accessToken ? `Bearer ${session.accessToken}` : "",
      }
    })
  });
});