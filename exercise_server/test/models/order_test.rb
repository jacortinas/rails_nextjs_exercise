require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "parses a CSV row" do
    test_file = Rails.root.join("test", "fixtures", "files", "test_data.csv")
    csv_data = CSV.readlines(test_file, headers: true, converters: :numeric)

    row = csv_data[0]
    order = Order.from_csv_row(row)

    assert_equal row["order_id"], order.order_id

    assert_equal Date.parse(row["ordered_at"]), order.ordered_at
    assert_equal Date.parse(row["ordered_at"]).year, order.year
    assert_equal Date.parse(row["ordered_at"]).month, order.month

    assert_equal row["item_type"], order.item_type
    assert_equal Money.from_amount(row["price_per_item"], "USD"), order.price_per_item
    assert_equal row["quantity"], order.quantity
    assert_equal Money.from_amount(row["shipping"], "USD"), order.shipping
    assert_equal row["tax_rate"], order.tax_rate

    total_payments = Money.from_amount(row["payment_1_amount"], "USD") + Money.from_amount(row["payment_2_amount"], "USD")
    assert_equal total_payments, order.payments

    assert_equal Money.from_amount(row["price_per_item"], "USD") * row["quantity"], order.sales
    assert_equal order.sales * row["tax_rate"], order.tax
  end
end
