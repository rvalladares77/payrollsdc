require 'rails_helper'

RSpec.describe Api::V1::CsvImportsController, type: :controller do
  render_views

  let(:csv_file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'time-report-42.csv')) }
  let(:job_group_a) { JobGroup.create(name: 'A', hourly_rate: 20) }
  let(:job_group_b) { JobGroup.create(name: 'B', hourly_rate: 30) }
  let(:employee1) { Employee.create(employee_id: '1', job_group: job_group_a) }
  let(:employee2) { Employee.create(employee_id: '2', job_group: job_group_b) }

  before(:each) do
    employee1
    employee2
  end
 
  describe 'POST create' do
    it 'creates the work log' do
      post :create, params: { file: csv_file }

      expect(response).to be_successful
      expect(WorkLog.all.count).to eq(3)
    end
  end
end

