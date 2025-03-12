module Types
  class SortDirectionEnum < GraphQL::Schema::Enum
    description "Direction in which to order a list of items."

    value "ASC", "Ascending order", value: :asc
    value "DESC", "Descending order", value: :desc
  end
end