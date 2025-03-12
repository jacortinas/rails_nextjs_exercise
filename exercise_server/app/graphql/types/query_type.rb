# frozen_string_literal: true

module Types
  class QueryType < GraphQL::Schema::Object
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    field :viewer, Types::ViewerType, null: false

    def viewer
      context[:current_user]
    end

    field :ledger, Types::LedgerType, null: false

    # In a real case this would be the Ledger for the current user,
    # or this ledger field would be nested in a `viewer` parent field.
    def ledger
      Ledger
    end
  end
end
