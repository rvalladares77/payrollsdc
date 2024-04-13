class AddJobGroupsToEmployees < ActiveRecord::Migration[7.1]
  def change
    add_reference :employees, :job_group, null: true, foreign_key: { on_delete: :nullify }
  end
end
