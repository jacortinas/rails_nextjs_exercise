module Types
  class LedgerType < GraphQL::Schema::Object
    description "A ledger of journal entries."

    field :years, Types::LedgerYearType.connection_type, "A list of years in the ledger.", null: false do
      argument :sort_direction, Types::SortDirectionEnum, required: false, default_value: :desc
    end

    def years(sort_direction: :desc)
      JournalEntry.order(year: sort_direction).distinct(:year).pluck(:year)
    end

    field :year, Types::LedgerYearType, "A specific year in the ledger.", null: true do
      argument :year, Integer, required: true
    end

    def year(year:)
      year if JournalEntry.where(year: year).exists?
    end

    field :entry, Types::JournalEntryType, "A specific journal entry for a given year and month.", null: true do
      argument :year, Integer, required: true
      argument :month, Integer, required: true
    end

    def entry(year:, month:)
      JournalEntry.find_by(year:, month:)
    end
  end
end