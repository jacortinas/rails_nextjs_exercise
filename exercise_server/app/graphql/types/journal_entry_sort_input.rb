class Types::JournalEntrySortInput < Types::BaseInputObject
  description "Properties by which journal entries can be ordered."
  argument :year, Types::SortDirectionEnum, required: false, default_value: :asc
  argument :month, Types::SortDirectionEnum, required: false, default_value: :asc
end