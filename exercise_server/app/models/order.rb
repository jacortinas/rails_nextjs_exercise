# typed: strict

class Order
  extend T::Sig

  sig { returns(Integer) }
  attr_reader :order_id

  sig { returns(Date) }
  attr_reader :ordered_at

  sig { returns(String) }
  attr_reader :item_type

  sig { returns(Money)}
  attr_reader :price_per_item

  sig { returns(Integer) }
  attr_reader :quantity

  sig { returns(Money) }
  attr_reader :shipping

  sig { returns(Numeric) }
  attr_reader :tax_rate

  sig { returns(Money) }
  attr_reader :payments

  sig { returns(Money) }
  attr_reader :sales

  sig { returns(Money) }
  attr_reader :tax

  # Transform from a CSV row with known attributes to an instance of the Order class. 
  sig { params(row: CSV::Row).returns(T.attached_class) }
  def self.from_csv_row(row)
    if row.any?(&:nil?)
      raise ArgumentError, "Missing required attributes in row: #{row}"
    end
    
    order = new(
      order_id:       row["order_id"],
      ordered_at:     row["ordered_at"],
      item_type:      row["item_type"],
      price_per_item: row["price_per_item"],
      quantity:       row["quantity"],
      shipping:       row["shipping"],
      tax_rate:       row["tax_rate"],
      payments:       row["payment_1_amount"].to_f + row["payment_2_amount"].to_f
    )

    order
  end

  sig {
    params(
      order_id: Integer,
      ordered_at: T.any(String, Date),
      item_type: String,
      price_per_item: Numeric,
      quantity: Integer,
      shipping: Numeric,
      tax_rate: Numeric,
      payments: Numeric
    ).void
  }
  def initialize(order_id:, ordered_at:, item_type:, price_per_item:, quantity:, shipping:, tax_rate:, payments:)
    @order_id = order_id
    @ordered_at = T.let(ordered_at.kind_of?(Date) ? ordered_at : Date.parse(ordered_at), Date)
    @item_type = item_type
    @price_per_item = T.let(Money.from_amount(price_per_item, "USD"), Money)
    @quantity = quantity
    @shipping = T.let(Money.from_amount(shipping, "USD"), Money)
    @tax_rate = tax_rate
    @payments = T.let(Money.from_amount(payments, "USD"), Money)

    @sales = T.let(@price_per_item * @quantity, Money)
    @tax = T.let(@sales * @tax_rate, Money)
  end

  sig { returns(Integer) }
  def year
    ordered_at.year
  end

  sig { returns(Integer) }
  def month
    ordered_at.month
  end
end
