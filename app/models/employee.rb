class Employee < ApplicationRecord
  belongs_to :job_group 

  has_many :work_logs, dependent: :destroy
  
  validates :employee_id, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :job_group, presence: true
end
