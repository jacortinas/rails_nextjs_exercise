class Types::JournalEntryType < Types::BaseObject
  description "A monthly journal entry in a ledger, derived from orders."

  implements Types::NodeType

  def id
    object.to_gid_param
  end

  field :year, Integer, null: false
  field :month, Integer, null: false

  field :sales_debit, Types::MoneyType, null: false
  field :sales_credit, Types::MoneyType, null: false

  field :shipping_debit, Types::MoneyType, null: false
  field :shipping_credit, Types::MoneyType, null: false

  field :tax_debit, Types::MoneyType, null: false
  field :tax_credit, Types::MoneyType, null: false

  field :cash_debit, Types::MoneyType, null: false
  field :cash_credit, Types::MoneyType, null: false

  field :total_debit, Types::MoneyType, null: false
  field :total_credit, Types::MoneyType, null: false
end