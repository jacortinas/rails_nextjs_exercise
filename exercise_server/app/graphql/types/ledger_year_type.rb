module Types
  class LedgerYearType < GraphQL::Schema::Object
    field :year, Integer, null: false

    def year
      object
    end

    field :entries, Types::JournalEntryType.connection_type, null: false do
      description "The journal entries for this year"
      argument :sort_direction, Types::SortDirectionEnum, required: false, default_value: :asc
    end

    def entries(sort_direction:)
      dataloader.with(Sources::JournalEntriesByYear, sort_direction:).load(object)
    end
  end
end