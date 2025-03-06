require "test_helper"

class GraphQL::LedgerJournalEntriesTest < ActionDispatch::IntegrationTest
  test "can query ledger.journalEntries" do
    query = <<-GRAPHQL
      query {
        ledger {
          __typename
          journalEntries(first: 1, sortBy: { year: DESC, month: DESC }) {
            pageInfo {
              hasNextPage
              endCursor
            }
            edges {
              cursor
              node {
                ...JournalEntryFields
              }
            }
          }
        }
      }

      fragment JournalEntryFields on JournalEntry {
        __typename
        id
        year
        month
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

      fragment MoneyFields on Money {
        __typename
        cents
      }
    GRAPHQL

    result = ExerciseServerSchema.execute(query)

    assert_nil result["errors"]
    assert_equal "Ledger", result.dig(*%w[data ledger __typename])
    assert_equal 1, result.dig(*%w[data ledger journalEntries edges]).size

    assert_equal(
      result.dig(*%w[data ledger journalEntries pageInfo endCursor]),
      result.dig("data", "ledger", "journalEntries", "edges", 0, "cursor")
    )

    assert result.dig(*%w[data ledger journalEntries pageInfo hasNextPage])

    entry = JournalEntry.order(year: :desc, month: :desc).first

    entry_result = result.dig("data", "ledger", "journalEntries", "edges", 0, "node")

    assert_equal "JournalEntry", entry_result["__typename"]
    assert_equal entry.to_gid_param, entry_result["id"]
    assert_equal entry.year, entry_result["year"]
    assert_equal entry.month, entry_result["month"]

    # Note: I know this is a different calling format than the dig(%w[]) usage above,
    # you only save some characters when its' more than 2 entries in the array of keys to dig.

    assert_equal "Money", entry_result.dig("salesDebit", "__typename")
    assert_equal entry.sales_debit.cents, entry_result.dig("salesDebit", "cents")
    assert_equal entry.sales_credit.cents, entry_result.dig("salesCredit", "cents")
    assert_equal entry.shipping_debit.cents, entry_result.dig("shippingDebit", "cents")
    assert_equal entry.shipping_credit.cents, entry_result.dig("shippingCredit", "cents")
    assert_equal entry.tax_debit.cents, entry_result.dig("taxDebit", "cents")
    assert_equal entry.tax_credit.cents, entry_result.dig("taxCredit", "cents")
    assert_equal entry.cash_debit.cents, entry_result.dig("cashDebit", "cents")
    assert_equal entry.cash_credit.cents, entry_result.dig("cashCredit", "cents")
    assert_equal entry.total_debit.cents, entry_result.dig("totalDebit", "cents")
    assert_equal entry.total_credit.cents, entry_result.dig("totalCredit", "cents")
  end
end