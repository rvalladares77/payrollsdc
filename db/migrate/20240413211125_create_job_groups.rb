class CreateJobGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :job_groups do |t|
      t.string :name, limit: 100, null: false
      t.decimal :hourly_rate, precision: 10, scale: 2, null: false

      t.timestamps
    end

    add_index :job_groups, :name, unique: true
  end
end
