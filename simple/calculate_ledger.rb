#! /usr/bin/env ruby

require "csv"
require "money"

I18n.config.available_locales = :en
Money.locale_backend = :i18n
Money.rounding_mode = BigDecimal::ROUND_HALF_EVEN

class Order
  attr_reader :order_id, :ordered_at, :item_type, :price_per_item, :quantity, :shipping, :tax_rate, :payments

  def initialize(order_row)
    @order_id = order_row["order_id"]
    @ordered_at = Date.parse(order_row["ordered_at"])
    @item_type = order_row["item_type"]
    @price_per_item = Money.from_amount(order_row["price_per_item"], "USD")
    @quantity = order_row["quantity"]
    @shipping = Money.from_amount(order_row["shipping"], "USD")
    @tax_rate = order_row["tax_rate"]
    @payments = []

    # All orders right now have a payment_1_{id,amount}
    # and some have a payment_2_{id,amount}. In the case
    # where the amount of payments were greater than 2, the
    # code would need to be refactored to loop from 1 to N
    # until no more payment related columns are found.
    @payments << {
      id: order_row["payment_1_id"],
      amount: Money.from_amount(order_row["payment_1_amount"], "USD"),
    }

    if order_row.key?("payment_2_id")
      @payments << {
        id: order_row["payment_2_id"],
        amount: Money.from_amount(order_row["payment_2_amount"], "USD"),
      }
    end
  end

  def year
    @ordered_at.year
  end

  def month
    @ordered_at.month
  end

  # Product sold without tax
  def sales
    price_per_item * quantity
  end

  # Tax cost based on sales and tax rate
  def tax
    sales * tax_rate
  end

  # Total amount paid, includes shippings and tax
  def payments_amount
    payments.sum { _1[:amount] }
  end
end

class JournalEntry
  attr_reader :year, :month, :orders, :sales, :shipping, :tax, :payments_amount

  def initialize(year, month)
    @year = year
    @month = month

    # Orders are stored keyed by order_id
    @orders = {}

    # Aggregate values
    @sales = 0
    @shipping = 0
    @tax = 0
    @payments_amount = 0
  end

  def add_order(order)
    @orders[order.order_id] = order

    @sales += order.sales
    @shipping += order.shipping
    @tax += order.tax
    @payments_amount += order.payments_amount
  end

  # Cash expected for orders
  def orders_debit
    sales + shipping
  end

  # Cash expected for shipping on orders
  def shipping_debit
    shipping
  end

  # Cash expected for taxes
  def tax_debit
    tax
  end

  # Cash received
  def cash_debit
    payments_amount
  end

  def total_debit
    orders_debit + shipping_debit + tax_debit + cash_debit
  end
  
  # Revenue for orders
  def orders_credit
    payments_amount - tax
  end

  # Revenue for shipping
  def shipping_credit
    payments_amount - sales - tax
  end
  
  def tax_credit
    payments_amount - sales - shipping
  end

  def cash_credit
    sales + shipping + tax
  end

  def total_credit
    orders_credit + shipping_credit + tax_credit + cash_credit
  end

  def to_s
    <<~STRING
      Journal Entry for #{year}-#{month}
      #{"-" * 40}
      Cash expected for orders #{orders_debit.format}
      Revenue for orders #{orders_credit.format}

      Cash expected for shipping on orders #{shipping_debit.format}
      Revenue for shipping #{shipping_credit.format}

      Cash expected for taxes #{tax_debit.format}
      Cash to be paid for sales tax #{tax_credit.format}

      Cash received #{cash_debit.format}
      Removal of expectation of cash #{cash_credit.format}

      Total Debit #{total_debit.format}
      Total Credit #{total_credit.format}
    STRING
  end
end

class Ledger
  attr_reader :journal_entries

  def initialize
    @journal_entries = {}
  end

  # Syncs the ledger with the data from a CSV file. Will reset all existing journal entries.
  def sync_from_file!(file_name)
    @journal_entries = {} unless @journal_entries.empty?

    # .foreach is memory efficient, iterates line by line.
    CSV.foreach(file_name, headers: true, converters: :numeric) do |row|
      order = Order.new(row)
      journal_entry = find_or_create_journal_entry(order.year, order.month)
      journal_entry.add_order(order)
    end
  end

  # Calls the block with each journal entry in year month ascending order.
  # If no block is given, returns an Enumerator.
  def each_entry
    if block_given?
      journal_entries.sort_by { _1 }.each { yield _2 }
    else
      journal_entries.sort_by { _1 }.to_enum
    end
  end

  private

  # Finds or creates a journal entry for the given year and month.
  def find_or_create_journal_entry(year, month)
    unless (journal_entry = @journal_entries[[year, month]])
      journal_entry = JournalEntry.new(year, month)
      @journal_entries[[year, month]] ||= journal_entry
    end

    journal_entry
  end

  def add_order(order)
    journal_entry = find_or_create_journal_entry(order.year, order.month)
    journal_entry.add_order(order)
  end
end

if __FILE__ == $PROGRAM_NAME
  if ARGV.empty?
    puts "Usage: #{$PROGRAM_NAME} <file.csv>"
    exit 1
  end

  ledger = Ledger.new
  ledger.sync_from_file!(ARGV[0])

  puts "Your Ledger"
  puts "=" * 40
  puts

  ledger.each_entry do |entry|
    puts entry.to_s
    puts
  end
end