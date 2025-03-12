import { handleYearMonthSelected } from "@/actions";
import { LEDGER_QUERY } from "@/queries";
import { query } from "@/apolloClient"
import { LedgerQueryResult, LedgerYear } from "@/types";
import { YearMonthSelect } from "@/app/ledger/YearMonthSelect";
import { Button } from "@/buttons";
import Form from "next/form";
import clsx from "clsx";

export type YearMonthFormProps = {
  years?: LedgerYear[];
}

export default async function YearMonthForm({ years }: YearMonthFormProps) {
  if (!years) {
    const response = await query<LedgerQueryResult>({ query: LEDGER_QUERY });
    const ledger = response.data.ledger;
    years = ledger.years?.nodes!;
  }

  return (
    <Form action={handleYearMonthSelected} className="flex flex-row gap-2">
      <YearMonthSelect
        years={years}
        name="date"
        className={clsx(
          "text-sm md:text-base font-medium rounded-md bg-white/20 p-2 hover:cursor-pointer hover:bg-white/30 active:bg-white/35"
        )}
      />
      <noscript>
        <Button type="submit" className="text-md font-medium rounded-md bg-white/20 p-2 hover:cursor-pointer hover:bg-white/30 active:bg-white/35">
          Go →
        </Button>
      </noscript>
    </Form>
  )
}