require 'rails_helper'

RSpec.describe WorkLogImporter do
  describe '#perform' do

    context 'when the CSV import is invalid' do
      context 'When the report ID already exists'
        let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'invalid-time-report-40.csv')) }

        it 'returns errors message and status' do
          CsvImport.create(filename: 'invalid-time-report-40.csv', report_id: 40)

          wl_importer = WorkLogImporter.new(file)

          expect(wl_importer.create).to be_empty
        end
    end

    context 'when the csv import is valid' do
      let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'time-report-42.csv')) }
      let(:employee) {Employee.create(employee_id: )}
      let(:job_group_a) { JobGroup.create(name: 'A', hourly_rate: 20) }
      let(:job_group_b) { JobGroup.create(name: 'B', hourly_rate: 30) }
      let(:employee1) { Employee.create(employee_id: '1', job_group: job_group_a)}
      let(:employee2) { Employee.create(employee_id: '2', job_group: job_group_b)}

      before(:each) do
        employee1
        employee2
      end

      it 'creats the work log entries' do
        wl_importer = WorkLogImporter.new(file).create

        expect(employee1.work_logs.first.work_date.strftime('%Y-%m-%d')).to eq('2023-11-14')
        expect(employee1.work_logs.first.hours_worked.hours).to eq(7.5.hours)

        employee2_dates = employee2.work_logs.map {|work_log|  work_log.work_date.strftime('%Y-%m-%d') }
        expect(employee2_dates).to match_array(['2023-11-09', '2023-11-10'])

        employee2_worked_hours = employee2.work_logs.map {|work_log|  work_log.hours_worked.hours}
        expect(employee2_worked_hours).to match_array([4.hours, 4.hours])

        expect(WorkLog.all.count).to eq(3)
      end

      context 'when an employee does not exists' do
        it 'returns a list of not found employee id' do
          employee1.update(job_group: job_group_b)
          wl_importer = WorkLogImporter.new(file).create

          expect(wl_importer).to match_array(["1"])
          expect(WorkLog.all.count).to eq(2)
        end
      end
    end
  end
end
