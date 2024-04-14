class Api::V1::PayrollReportController < ApplicationController

  def index
    payroll_report = PayrollReportService.new.generate

    render json: { payrollReport: { employeeReports: payroll_report }} , status: :created
  end
end
