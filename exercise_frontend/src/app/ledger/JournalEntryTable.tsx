import clsx from "clsx";
import { FullJournalEntry } from "@/types";

export type JournalEntryTableProps = {
  entry: FullJournalEntry;
}

export default function JournalEntryTable({ entry }: JournalEntryTableProps) {
  const entryLineItems= [
    ["Accounts Receivable", entry.salesDebit.formatted,    null,                           "Cash expected for orders"],
    ["Revenue",             null,                          entry.salesCredit.formatted,    "Revenue for orders"],
    ["Accounts Receivable", entry.shippingDebit.formatted, null,                           "Cash expected for shipping on orders"],
    ["Shipping Revenue",    null,                          entry.shippingCredit.formatted, "Revenue for shipping"],
    ["Account Receivable",  entry.taxDebit.formatted,      null,                           "Cash expected for taxes"],
    ["Sales Tax Payable",   null,                          entry.taxCredit.formatted,      "Cash to be paid for sales tax"],
    ["Cash",                entry.cashDebit.formatted,     null,                           "Cash received"],
    ["Account Receivable",  null,                          entry.cashCredit.formatted,     "Removal of expectation of cash"],
    [null,                  entry.totalDebit.formatted,    entry.totalCredit.formatted,    null]
  ]

  const thClassNames = "font-bold border-t border-white/20 py-2.5 bg-white/10";
  const tdClassNames = "font-medium border-t border-white/20 py-2.5";

  return (
    <table className="table-fixed text-left w-full rounded-md text-xs md:text-sm">
      <thead>
        <tr>
          <th className={clsx(thClassNames, "pl-4 pr-1 md:pr-2 w-3/12 border-r")}>Account</th>
          <th className={clsx(thClassNames, "px-1 md:px-2 w-2/12 border-r")}>Debit</th>
          <th className={clsx(thClassNames, "px-1 md:px-2 w-2/12 border-r")}>Credit</th>
          <th className={clsx(thClassNames, "px-1 md:px-2 w-5/12")}>Description</th>
        </tr>
      </thead>
      <tbody>
        {entryLineItems.map((lineItemRow, rowIndex) => (
          <tr key={rowIndex}>
            {lineItemRow.map((lineItemCell, dataIndex) => {
              const specificClasses = []

              if (dataIndex == 0) {
                specificClasses.push("pl-4 pr-1 md:pr-2 border-r");
              } else if (dataIndex == 1) {
                specificClasses.push("px-1 md:px-2 border-r");
              } else if (dataIndex == 2) {
                specificClasses.push("px-1 md:px-2 border-r");
              } else  {
                specificClasses.push("px-1 md:px-2");
              }

              if (rowIndex == entryLineItems.length - 1) {
                specificClasses.push("py-5");
              }

              return (
                <td key={`${rowIndex}-${dataIndex}`} className={clsx(tdClassNames, specificClasses)} >
                  {lineItemCell}
                </td>
              )
            })}
          </tr>
         ))}
      </tbody>
    </table>
  );
};