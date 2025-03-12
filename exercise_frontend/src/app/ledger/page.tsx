import YearMonthForm from "@/app/ledger/YearMonthForm";

import { query } from "@/apolloClient";
import { LEDGER_QUERY } from "@/queries";
import { LedgerQueryResult } from "@/types";

export default async function LedgerPage() {
  const response = await query<LedgerQueryResult>({ query: LEDGER_QUERY });
  const ledger = response.data.ledger;
  const years = ledger.years?.nodes!;

  return (
    <>
      <div className="p-4 text-white flex flex-row items-center justify-end">
        <YearMonthForm years={years} />
      </div>
      <div className="flex flex-row items-center justify-center px-8 pt-40 pb-48">
        <p className="text-center">Welcome, select a date from the dropdown to view that entry.</p>
      </div>
    </>
  );
}

