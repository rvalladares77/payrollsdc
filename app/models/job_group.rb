class JobGroup < ApplicationRecord
  has_many :employees
  has_many :work_logs
  
  validates :name, presence: true, uniqueness: true
  validates :hourly_rate, presence: true, numericality: { greater_than: 0 }
end
