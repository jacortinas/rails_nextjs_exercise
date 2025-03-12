"use client";

import { LEDGER_QUERY } from "@/queries";
import { LedgerQueryResult, LedgerYear, Ledger } from "@/types";
import { ReactElement, Suspense } from "react";
import { useSuspenseQuery, useReadQuery, ApolloQueryResult } from "@apollo/client";
import { useParams, useRouter } from "next/navigation";
import { use } from "react";

export type YearMonthSelectProps = {
  years: LedgerYear[];
  name: string;
  className?: string;
}

export const YearMonthSelect: React.FC<YearMonthSelectProps> = (props) => {
  const { name, className, years } = props;

  const params = useParams<{ year: string, month: string }>();
  const router = useRouter();

  const initialValue = params.year && params.month ? dateToKey(params.year, params.month) : "";

  const onSelectChange = (event: React.ChangeEvent<HTMLSelectElement>) => {
      const [year, month] = event.target.value.split('-').map(Number);

      if (year && month) {
        router.push(`/ledger/${year}/${month}`);
      } else {
        router.push("/ledger")
      }
  }

  return (
    <select
      name={name}
      className={className}
      onChange={onSelectChange}
      defaultValue={initialValue}
    >
      <option key="disabled-placeholder">Select Journal Entry</option>
      {makeOptions(years)}
    </select>
  )
}

function makeOptions(yearNodes: LedgerYear[] | undefined){
  const options: ReactElement<HTMLOptionElement>[] = [];

  yearNodes?.forEach((year: any, index: number) => {
    options.push(separatorOption(index));

    year.entries.nodes.forEach((month: any) => {
      options.push(optionFor(year.year, month.month, month.monthName));
    });
  });

  return options;
}

function dateToKey(year: number | string, month: number | string): string {
  return `${year.toString()}-${month.toString().padStart(2, "0")}`;
}

function separatorOption(index: number): ReactElement<HTMLOptionElement> {
  return <option disabled key={`disabled-${index}`}>--------------------</option>;
}

function optionFor(year: number, month: number, monthName: string): ReactElement<HTMLOptionElement> {
  const dateKey = dateToKey(year, month);
  return <option key={dateKey} value={dateKey}>{year} {monthName}</option>;
}

export default YearMonthSelect;