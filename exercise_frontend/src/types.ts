export type LedgerQueryResult = {
  ledger: Ledger
}

export type Ledger = {
  __typename: "Ledger"
  years?: {
    nodes: LedgerYear[]
  }
  year?: LedgerYear
  entry?: FullJournalEntry | SimpleJournalEntry
}

export type LedgerYear = {
  __typename: "JournalEntryYear"
  year: number
  entries: {
    nodes: SimpleJournalEntry[] | FullJournalEntry[]
  }
}

export type SimpleJournalEntry = {
  __typename: "JournalEntry"
  id: string
  year: number
  month: number
  monthName: string
}

export type FullJournalEntry = {
  salesDebit:MoneyType
  salesCredit: MoneyType
  shippingDebit: MoneyType
  shippingCredit: MoneyType
  taxDebit: MoneyType
  taxCredit: MoneyType
  cashDebit: MoneyType
  cashCredit: MoneyType
  totalDebit: MoneyType
  totalCredit: MoneyType
} & SimpleJournalEntry

export type MoneyType = {
  __typename: "MoneyType"
  cents: number
  formatted: string
  currencyIso: string
}
