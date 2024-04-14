require 'rails_helper'

RSpec.describe Api::V1::PayrollReportController, type: :controller do
  render_views

  let(:job_group_a) { JobGroup.create(name: 'A', hourly_rate: 20) }
  let(:job_group_b) { JobGroup.create(name: 'B', hourly_rate: 30) }
  let(:employee1) { Employee.create(employee_id: '1', job_group: job_group_a) }
  let(:employee2) { Employee.create(employee_id: '2', job_group: job_group_b) }

  before(:each) do
    WorkLog.create([
      { employee: employee1, work_date: '2023-01-02', hours_worked: 5, job_group: job_group_a},
      { employee: employee1, work_date: '2023-01-20', hours_worked: 2, job_group: job_group_a},
      { employee: employee2, work_date: '2023-03-20', hours_worked: 7, job_group: job_group_b}
    ])
  end
 
  describe 'GET /api/v1/payroll_report' do
    it 'return a JSON payrollreport' do
      get :index

      expect(response).to have_http_status(:success)

      payroll_report = JSON.parse(response.body)

      expect(payroll_report).to include('payrollReport')
      expect(payroll_report['payrollReport']).to include('employeeReports')

      expect_reports = [
        {"employeeId"=>1, "payPeriod"=>{"startDate"=>"2023-01-01", "endDate"=>"2023-01-15"}, "amountPaid"=>"$100.0"},
        {"employeeId"=>1, "payPeriod"=>{"startDate"=>"2023-01-16", "endDate"=>"2023-01-31"}, "amountPaid"=>"$40.0"},
        {"employeeId"=>2, "payPeriod"=>{"startDate"=>"2023-03-16", "endDate"=>"2023-03-31"}, "amountPaid"=>"$210.0"}]

      expect(payroll_report['payrollReport']['employeeReports']).to match_array(expect_reports)
    end
  end
end

