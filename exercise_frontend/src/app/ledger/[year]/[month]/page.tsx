import { query } from "@/apolloClient";
import { LEDGER_ENTRY_QUERY } from "@/queries";
import { FullJournalEntry, LedgerQueryResult, LedgerYear } from "@/types";

import YearMonthForm from "@/app/ledger/YearMonthForm";
import JournalEntryTable from "@/app/ledger/JournalEntryTable";

export type YearMonthPageProps = {
  params: Promise<{
    year: string;
    month: string;
  }>
};

export default async function YearMonthPage(props: YearMonthPageProps) {
  const params = await props.params;
  const year = parseInt(params.year);
  const month = parseInt(params.month);
  const response = await query<LedgerQueryResult>({ query: LEDGER_ENTRY_QUERY, variables: { year, month } });

  const ledger = response.data.ledger;
  const entry = ledger.entry! as FullJournalEntry;
  const years = ledger.years?.nodes as LedgerYear[];

  const lastDay = new Date(year, month, 0).getDate();

  const headlineSeparator = (text: string) => (<span className="text-white/40">{text}</span>);
  const headlineText = (text: any) => (<span>{text}</span>);

  return (
    <>
      <div className="p-4 text-white flex flex-row justify-between items-center">
        <h2 className="text-md sm:text-lg md:text-xl">
          {headlineText(month)}
          {headlineSeparator("/")}
          {headlineText(1)}
          {headlineSeparator("/")}
          {headlineText(year)}
          {headlineSeparator(" -  ")}
          {headlineText(month)}
          {headlineSeparator("/")}
          {headlineText(lastDay)}
          {headlineSeparator("/")}
          {headlineText(year)}
        </h2>
        <YearMonthForm years={years} />
      </div>
      <JournalEntryTable entry={entry} />
    </>
  )
}

