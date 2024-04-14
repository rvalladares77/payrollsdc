require 'csv'

class WorkLogImporter
  attr_reader :file

  ZERO = 0


  def initialize(file)
    @file = file
  end


  def create
    pp invalid_import?
    return error_message if invalid_import?

    create_work_log


    success_message
  end


  private

    def create_work_log
      import = CsvImport.create(filename: file.original_filename, report_id: report_id)
      work_logs = []


      CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
        employee = fetch_employee(row[:employee_id], row[:job_group])
        
        next if employee.nil?

        work_logs << {
          employee_id:   employee.id,
          work_date:     row[:date],
          hours_worked:  row[:hours_worked],
          csv_import_id: import.id
        }

      end

      WorkLog.insert_all(work_logs)
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

    def error_message
      [{ error: 'File with the same report ID already exists' }, :unprocessable_entity]
    end

    def success_message
      [{ message: 'The CSV was uploaded successfully' }, :created]
    end
end
