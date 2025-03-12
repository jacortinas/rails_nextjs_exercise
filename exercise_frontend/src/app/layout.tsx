import type { Metadata } from "next";
import ApolloWrapper from "@/app/ApolloWrapper";

import "./globals.css";

export const metadata: Metadata = {
  title: "Ledger Exercise",
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en" className="h-full w-full">
      <body className="bg-gradient-to-tr from-teal-600 via-cyan-500 to-indigo-400 text-white antialiased">
        <ApolloWrapper>
          {children}
        </ApolloWrapper>
      </body>
    </html>
  );
}
