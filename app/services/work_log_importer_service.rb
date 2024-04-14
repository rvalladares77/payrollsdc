require 'csv'

class WorkLogImporterService
  attr_reader :file

  def initialize(file)
    @file = file
  end


  def create
    return ['Import already exist'] if invalid_import?

    create_work_log
  end


  private

    def create_work_log
      import = CsvImport.create(filename: file.original_filename, report_id: report_id)
      work_logs = []
      errors = []

      CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
        employee = fetch_employee(row[:employee_id], row[:job_group])

        if employee.present?
          work_logs << work_log_attributes(employee, import, row)
        else
          errors << row[:employee_id]
        end
      end

      WorkLog.insert_all(work_logs)

      errors
    end

    def fetch_employee(employee_id, job_group)
      Employee.joins(:job_group).find_by(employees: { employee_id: employee_id }, job_groups: { name: job_group })
    end


    def invalid_import?
      CsvImport.where(report_id: report_id).exists?
    end


    def report_id
      @report_id = extract_report_id
    end

    def extract_report_id
      file.original_filename.match(/\d+/).to_s.to_i
    end

    def work_log_attributes(employee, import, row)
      {
        employee_id:   employee.id,
        work_date:     row[:date],
        hours_worked:  row[:hours_worked],
        csv_import_id: import.id,
        job_group_id:  employee.job_group_id
      }

    end
end
