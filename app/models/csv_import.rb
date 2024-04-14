class CsvImport < ApplicationRecord
  has_many :work_logs

  validates :report_id, presence: true, uniqueness: true
  validates :filename, presence: true, uniqueness: true
end
