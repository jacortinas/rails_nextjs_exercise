# typed: strict

# For the purposes of this exercise, Ledger is a PORO that acts as an entrypoint for
# associating with journal entries and recalculating data. In a real app this would most
# likly belong to a User or Organization kind of model.
class Ledger
  extend T::Sig

  # Returns a JournalEntry relation of all entries sorted by year then month.
  sig { returns(ActiveRecord::Relation) }
  def self.journal_entries
    JournalEntry.order(year: :asc, month: :asc)
  end

  # Load order data from a CSV file, aggregating the debit and credits by year and month.
  # Deletes and writes new JournalEntry records. 
  #
  # I debated whether I should store the order data in the DB or not. I decided not to in this initial
  # implementation as the requirements did not state the need to review order data, nor the need
  # to read other CSV files to append, delete, or update order data. This implementation assumes that
  # the CSV file is the source of truth for all order data and that the order data is complete.
  #
  # Order is a simple PORO from transforming the CSV data into structured data.
  # This is a situation where the order attributes could be batched and upserted to write Order records.
  # Upserting the data leaves the question of what do with records that exist in the DB
  # but are not in the CSV file. Should unreferenced rows be found and deleted or should
  # they be left alone? If we switched to upserting Order data into a SQL table then the
  # aggregate data should be recalculated using SQL queries after all order rows have been written.
  #
  # Here is an example of what it would look like if orders were stored in the DB and JournalEntry
  # records recalculated using SQL queries on those orders.
  #
  #   entry = ... # find or create the journal entry for the year and month
  #   orders = Order.where(ordered_at: Date.new(year, month).all_month)
  #   entry.sales = orders.sum(:sales) # Using ActiveRecord::Relation calcaulation methods
  #   entry.shipping = orders.sum(:shipping)
  #   entry.tax = orders.sum(:tax)
  #   entry.payments = orders.sum(:payments)
  #
  # You would have 4 aggregate queries to calculate the data for each journal entry for all of the orders
  # in a given month.
  #
  # Assuming however that the order CSV is for bulk loading valid data and and the order data is complete,
  # then the following single loop over all of the order data is sufficient. Journal entry aggregate values
  # are summed for each year/month while iterating the loop and then written all at once to the DB in a single
  # insert statement.
  sig { params(file_name: String).void }
  def self.reset_from_csv_file!(file_name)
    raise ArgumentError, "File not found: #{file_name}" unless File.exist?(file_name)

    # This hash will be used to store the aggregate data for each year/month found in the CSV file.
    entries_by_year_month = T::Hash[[Integer, Integer], JournalEntry].new

    # Iterating this way means that only a single row and Order model is in memory at a time.
    # headers: true options means we definitely have a CSV::Row instance.
    CSV.foreach(file_name, headers: true, converters: :numeric) do |row|
      row = T.cast(row, CSV::Row)
      order = Order.from_csv_row(row)
      date_key = [order.year, order.month]

      # Initialize and "cache" the entry data for `date_key` if it doesn't exist yet.
      entries_by_year_month[date_key] ||= JournalEntry.new(year: order.year, month: order.month)
      T.must(entries_by_year_month[date_key]).compute_order!(order)
    end

    entries_attributes = entries_by_year_month.values.map { _1.attributes.compact }

    # Option A: Don't delete anything and upsert to overwrite entries based on year and month.
    #
    # JournalEntry.upsert_all(entries_attributes, unique_by: %i[year month])

    # Option B: Delete All and Install All from scratch
    # Note: Tests expect option B to be used, and will fail if you switch to option A.
    # 
    ActiveRecord::Base.transaction do
      JournalEntry.delete_all
      JournalEntry.insert_all!(entries_attributes)
    end
  end
end