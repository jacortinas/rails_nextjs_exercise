# typed: strict

class JournalEntry < ApplicationRecord
  extend T::Sig

  monetize :sales_cents
  monetize :shipping_cents
  monetize :tax_cents
  monetize :payments_cents

  # The following methods are mainly for my own convenience,
  # they match up with the expected output. This output
  # of the following methods could be calculated ahead of time and
  # stored denormalized in the database.

  # Cash expected for orders
  sig { returns(Money) }
  def sales_debit
    sales
  end

  # Revenue for orders
  sig { returns(Money) }
  def sales_credit
    payments - tax - shipping
  end

  # Cash expected for shipping on orders
  sig { returns(Money) }
  def shipping_debit
    shipping
  end

  # Revenue for shipping
  sig { returns(Money) }
  def shipping_credit
    payments - sales - tax
  end

  # Cash expected for taxes
  sig { returns(Money) }
  def tax_debit
    tax
  end

  # Cash to be paid for sales tax
  sig { returns(Money) }
  def tax_credit
    payments - sales - shipping
  end

  # Cash received
  sig { returns(Money) }
  def cash_debit
    payments
  end

  # Removal of expectation of cash
  sig { returns(Money) }
  def cash_credit
    sales + shipping + tax
  end

  # Total of all debits
  sig { returns(Money) }
  def total_debit
    sales_debit + shipping_debit + tax_debit + cash_debit
  end

  # Total of all credits
  sig { returns(Money) }
  def total_credit
    sales_credit + shipping_credit + tax_credit + cash_credit
  end

  # Adds the order data to the journal entry. Modifies the journal entry in place.
  sig { params(order: Order).void }
  def compute_order!(order)
    self.sales += order.sales
    self.shipping += order.shipping
    self.tax += order.tax
    self.payments += order.payments
  end

  sig { returns(String) }
  def formatted_output
    <<~STRING
      Journal Entry for #{year}-#{month}
      #{"-" * 40}
      Cash expected for orders #{sales_debit.format}
      Revenue for orders #{sales_credit.format}

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
