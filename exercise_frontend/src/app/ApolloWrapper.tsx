"use client";

import { HttpLink } from "@apollo/client";
import {
  ApolloNextAppProvider,
  ApolloClient,
  InMemoryCache
} from "@apollo/experimental-nextjs-app-support";

function makeClient() {
  const httpLink = new HttpLink({
    uri: "http://localhost:3000/graphql",
    fetchOptions: { cache: "no-store" }
  })

  return new ApolloClient({
    cache: new InMemoryCache(),
    link: httpLink,
  });
}

export default function ApolloWrapper({ children } : { children: React.ReactNode }) {
  return (
    <ApolloNextAppProvider makeClient={makeClient}>
      {children}
    </ApolloNextAppProvider>
  )
}