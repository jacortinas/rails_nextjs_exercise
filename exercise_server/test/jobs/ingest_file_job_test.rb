require "test_helper"

class IngestFileJobTest < ActiveJob::TestCase
  test "expects the ledger to be reset with file contents" do
    file_path = Rails.root.join(*%w[test fixtures files test_data.csv]).to_s
    Ledger.expects(:reset_from_csv_file!).with(file_path)
    IngestFileJob.perform_now(file_path)
  end
end
