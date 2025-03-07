module Types
  class LedgerType < Types::BaseObject
    description "A ledger of journal entries."

    field :journal_entries, Types::JournalEntryType.connection_type, null: false do
      argument :sort_by, Types::JournalEntrySortInput, required: false, default_value: { year: :asc, month: :asc }
    end

    def journal_entries(sort_by:)
      if sort_by
        object.journal_entries.reorder(sort_by.to_h)
      else
        object.journal_entries
      end
    end
  end
end