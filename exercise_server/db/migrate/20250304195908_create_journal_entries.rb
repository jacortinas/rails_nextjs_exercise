class CreateJournalEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :journal_entries do |t|
      t.integer :year, null: false
      t.integer :month, null: false

      t.integer :sales_cents, default: 0, null: false
      t.integer :shipping_cents, default: 0, null: false
      t.integer :tax_cents, default: 0, null: false
      t.integer :payments_cents, default: 0, null: false

      t.timestamps

      t.index [:year, :month], unique: true
    end
  end
end
