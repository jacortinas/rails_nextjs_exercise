module Types
  class MoneyType < GraphQL::Schema::Object
    description "An amount of money, represented as a whole number of cents in the currency's smallest unit."

    field :cents, Integer, null: false

    field :formatted, String, null: false

    def formatted
      object.format
    end

    field :currency_iso, String, null: false

    def currency_iso
      object.currency.iso_code.to_s
    end
  end
end