"use server";

import { AuthError } from "next-auth";
import { signIn, signOut } from "@/auth";
import { redirect } from "next/navigation";

export async function attemptSignIn() {
  try {
    await signIn("ledger_api", { redirectTo: "/ledger" });
  } catch(error) {
    if (error instanceof AuthError) {
      console.error("SignInButton error -", error);
    } else {
      throw error;
    }
  }
}

export async function attemptSignOut() {
  await signOut({ redirectTo: "/" });
}

export async function handleYearMonthSelected(formData: FormData) {
  const [year, month] = formData.get("date")?.toString().split('-').map(Number) || [];

  if (year && month) {
    return redirect(`/ledger/${year}/${month}`);
  } else {
    return redirect("/ledger");
  }
}