class CreateWorkLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :work_logs do |t|
      t.references :employee, null: false, foreign_key: { on_delete: :cascade }
      t.date :work_date, null: false
      t.decimal :hours_worked, precision: 5, scale: 2, null: false
      t.references :csv_import, foreign_key: { on_delete: :nullify }

      t.timestamps
    end

    add_index :work_logs, :work_date
  end
end
