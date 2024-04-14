class AddJobGroupsToWorkLogs < ActiveRecord::Migration[7.1]
  def change
    add_reference :work_logs, :job_group, null: false, foreign_key: { on_delete: :cascade }
  end
end
