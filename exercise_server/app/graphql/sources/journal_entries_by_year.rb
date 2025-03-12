module Sources
  class JournalEntriesByYear < GraphQL::Dataloader::Source
    def initialize(sort_direction: "desc")
      @sort_direction = sort_direction
    end

    def fetch(years)
      grouped_entries = JournalEntry.where(year: Array.wrap(years)).order(month: @sort_direction).group_by(&:year)
      years.map { |year| grouped_entries[year] }
    end
  end
end