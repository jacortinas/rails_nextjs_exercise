module Types
  class ViewerType < Types::BaseObject
    implements Types::NodeType

    def id
      object.to_gid_param
    end

    field :email, String, null: false
  end
end
