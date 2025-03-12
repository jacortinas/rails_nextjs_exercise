import { SignOutButton } from "@/buttons";
import Link from "next/link";

export default async function DashboardLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="mx-auto flex max-w-3xl min-w-sm flex-col">
      <div className="flex flex-row items-center py-8 pl-4 md:pl-0">
        <Link href="/ledger">
          <h1 className="text-5xl font-light text-white">Ledger</h1>
        </Link>
        <SignOutButton containerClassName="ml-auto pr-4 md:pr-0" className="font-medium"/>
      </div>
      <div className="overflow-hidden md:rounded-md shadow-lg bg-gradient-to-tr from-indigo-600 to-sky-600">
        {children}
      </div>
    </div>
  )
}
