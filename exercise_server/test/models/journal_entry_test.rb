require "test_helper"

class JournalEntryTest < ActiveSupport::TestCase
  test "has expected values" do
    entry = journal_entries(:one) # First test fixture

    assert_equal 2024, entry.year
    assert_equal 1, entry.month

    assert_equal Money.from_amount(10_000, "USD"), entry.sales
    assert_equal 1_000_000, entry.sales_cents

    assert_equal Money.from_amount(1_000, "USD"), entry.shipping
    assert_equal 100_000, entry.shipping_cents

    assert_equal Money.from_amount(500, "USD"), entry.tax
    assert_equal 50_000, entry.tax_cents

    assert_equal Money.from_amount(11_500, "USD"), entry.payments
    assert_equal 1_150_000, entry.payments_cents

    # Orders debit & credit
    assert_equal Money.from_amount(10_000, "USD"), entry.sales_debit
    assert_equal Money.from_amount(10_000, "USD"), entry.sales_credit

    # Shipping debit & credit
    assert_equal Money.from_amount(1_000, "USD"), entry.shipping_debit
    assert_equal Money.from_amount(1_000, "USD"), entry.shipping_credit

    # Tax debit & credit
    assert_equal Money.from_amount(500, "USD"), entry.tax_debit
    assert_equal Money.from_amount(500, "USD"), entry.tax_credit

    # Cash debit & credit
    assert_equal Money.from_amount(11_500, "USD"), entry.cash_debit
    assert_equal Money.from_amount(11_500, "USD"), entry.cash_credit

    # Total debit & credit
    assert_equal Money.from_amount(23_000, "USD"), entry.total_debit
    assert_equal Money.from_amount(23_000, "USD"), entry.total_credit
  end
end
