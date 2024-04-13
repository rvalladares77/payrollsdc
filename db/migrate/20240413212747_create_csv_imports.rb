class CreateCsvImports < ActiveRecord::Migration[7.1]
  def change
    create_table :csv_imports do |t|
      t.string :filename, null: false
      t.integer :report_id, null: false

      t.timestamps
    end

    add_index :csv_imports, :filename, unique: true
    add_index :csv_imports, :report_id, unique: true
  end
end
