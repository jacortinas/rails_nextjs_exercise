require "test_helper"

class LedgerTest < ActiveSupport::TestCase
  test "has journal entries sorted by year and month" do
    assert_predicate JournalEntry, :any?
    assert_equal JournalEntry.order(year: :desc, month: :asc).to_a, Ledger.journal_entries.to_a
  end

  test "resets all journal entries from a CSV file" do
    assert_changes -> { JournalEntry.count }, from: 3, to: 1 do
      Ledger.reset_from_csv_file!(Rails.root.join(*%w[test fixtures files test_data.csv]).to_s)
    end

    # This is data derived from the two order rows in the test_data.csv file.
    test_entry = JournalEntry.first

    assert_equal 2024,  test_entry.year
    assert_equal 2,     test_entry.month
    assert_equal 800,   test_entry.sales_cents
    assert_equal 600,   test_entry.shipping_cents
    assert_equal 400,   test_entry.tax_cents
    assert_equal 1_800, test_entry.payments_cents
  end
end
