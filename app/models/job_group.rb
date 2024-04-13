class JobGroup < ApplicationRecord
  has_many :employees
  
  validates :name, presence: true, uniqueness: true
  validates :hourly_rate, presence: true, numericality: { greater_than: 0 }
end
