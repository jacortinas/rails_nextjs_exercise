require "sorbet-runtime"

namespace :data do
  task import: :environment do
    file_path = Rails.root.join("data", "data.csv").to_s

    puts "Importing data from #{file_path}"

    # This immediately runs the job and blocks execution until it's complete.
    # This could be changed to `perform_later` if the job should be backgrounded
    # because it's long running or needs to spawn other sub-jobs to complete it's work.
    IngestFileJob.perform_now(file_path)

    puts "Data imported successfully"
    puts

    Ledger.journal_entries.each { puts _1.to_s }
  end 
end