module Types
  class ViewerType < GraphQL::Schema::Object
    implements Types::NodeType

    def id
      object.to_gid_param
    end

    field :email, String, null: false
  end
end
