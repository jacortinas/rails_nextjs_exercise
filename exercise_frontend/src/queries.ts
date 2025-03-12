import { gql } from "@apollo/client";

export const MONEY_FRAGMENT = gql`
  fragment MoneyFields on Money {
    cents
    formatted
    currencyIso
  }
`;

// A basic query to get the list of years and months available in the ledger.
export const LEDGER_QUERY = gql`
  query LedgerQuery {
    ledger {
      years(sortDirection: DESC) {
        nodes {
          year
          entries(sortDirection: ASC, first: 12) {
            nodes {
              id
              year
              month
              monthName
            }
          }
        }
      }
    }
  }
`;

// A query to get a specific journal entry for a given year and month.
// Includes the full list of years and months to be able to reload the
// year/month select without making any extra queries.
export const LEDGER_ENTRY_QUERY = gql`
  query LedgerEntryQuery($year: Int!, $month: Int!) {
    ledger {
      years(sortDirection: DESC) {
        nodes {
          year
          entries(sortDirection: ASC, first: 12) {
            nodes {
              id
              year
              month
              monthName
            }
          }
        }
      }
      entry(year: $year, month: $month) {
        id
        year
        month
        monthName
        salesDebit { ...MoneyFields }
        salesCredit { ...MoneyFields }
        shippingDebit { ...MoneyFields }
        shippingCredit { ...MoneyFields }
        taxDebit { ...MoneyFields }
        taxCredit { ...MoneyFields }
        cashDebit { ...MoneyFields }
        cashCredit { ...MoneyFields }
        totalDebit { ...MoneyFields }
        totalCredit { ...MoneyFields }
      }
    }
  }
  ${MONEY_FRAGMENT}
`;