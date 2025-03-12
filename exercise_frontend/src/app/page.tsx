import { auth } from "@/auth";
import { SignInButton, SignOutButton } from "@/buttons";
import Link from "next/link";

function AuthenticatedHome({ user }: { user: { email: string } }) {
  const email = user?.email || "unknown";

  return (
    <div className="text-center">
      <p className="text-lg mb-8">Welcome back {email}</p>
      <Link href="/ledger" className="px-5 py-2 bg-white/20 rounded-sm md:rouned-md text-white hover:cursor-pointer hover:bg-white/30 active:bg-white/35">
        View the ledger
      </Link>
    </div>
  )
}

function UnauthenticatedHome() {
  return (
    <SignInButton/>
  )
}

export default async function RootPage() {
  const session = await auth();

  console.log("Session:", session);

  const content = session?.user ? <AuthenticatedHome user={session.user}/> : <UnauthenticatedHome/>;

  return (
    <div className="flex flex-col items-center justify-center min-h-screen">
      <h1 className="text-4xl text-white mb-8">Ledger Exercise</h1>
      {content}
    </div>
  );
}

