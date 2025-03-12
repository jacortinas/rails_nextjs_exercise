module Sources
  class GlobalId < GraphQL::Dataloader::Source
    def fetch(gids)
      GlobalID::Locator.locate_many(gids)
    end
  end
end