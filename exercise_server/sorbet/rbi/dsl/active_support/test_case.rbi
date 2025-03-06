# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `ActiveSupport::TestCase`.
# Please instead update this file by running `bin/tapioca dsl ActiveSupport::TestCase`.


class ActiveSupport::TestCase
  sig { params(fixture_name: NilClass, other_fixtures: NilClass).returns(T::Array[JournalEntry]) }
  sig { params(fixture_name: T.any(String, Symbol), other_fixtures: NilClass).returns(JournalEntry) }
  sig do
    params(
      fixture_name: T.any(String, Symbol),
      other_fixtures: T.any(String, Symbol)
    ).returns(T::Array[JournalEntry])
  end
  def journal_entries(fixture_name = nil, *other_fixtures); end
end
