class CsvImport < ApplicationRecord
  has_many :work_logs

  validates :report_id, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
