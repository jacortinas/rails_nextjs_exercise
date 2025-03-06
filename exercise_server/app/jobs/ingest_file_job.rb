class IngestFileJob < ApplicationJob
  queue_as :default

  def perform(file_name)
    Ledger.reset_from_csv_file!(file_name)
  end
end
