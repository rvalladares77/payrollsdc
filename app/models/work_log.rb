class WorkLog < ApplicationRecord
  belongs_to :employee
  belongs_to :csv_import, optional: true

  validates :work_date, presence: true
  validates :hours_worked, presence: true, numericality: { greater_than: 0 }
end
