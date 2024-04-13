class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.string :employee_id, limit: 100, null: false

      t.timestamps
    end

    add_index :employees, :employee_id, unique: true
  end
end
