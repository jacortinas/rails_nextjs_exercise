# typed: true

class JournalEntry < ApplicationRecord
  sig { returns(Money) }
  def sales; end

  sig { params(value: Money).returns(Money) }
  def sales=(value); end

  sig { returns(Money) }
  def shipping; end

  sig { params(value: Money).returns(Money) }
  def shipping=(value); end

  sig { returns(Money) }
  def tax; end

  sig { params(value: Money).returns(Money) }
  def tax=(value); end

  sig { returns(Money) }
  def payments; end

  sig { params(value: Money).returns(Money) }
  def payments=(value); end
end