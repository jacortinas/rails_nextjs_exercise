# frozen_string_literal: true

module Types
  module NodeType
    include GraphQL::Schema::Interface

    # Add the `id` field
    include GraphQL::Types::Relay::NodeBehaviors
  end
end
