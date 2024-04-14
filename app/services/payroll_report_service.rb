class PayrollReportService

  def generate
    generate_payroll_report
  end

  private


      def generate_payroll_report
        # Initialize an empty hash to store the payroll report
        payroll_report = {}

        work_logs = fetch_grouped_work_log

        # Iterate over the work logs to construct the payroll report
        work_logs.each do |log|
          employee_id = log.employee_id
          hourly_rate = log.hourly_rate
          year = log.year
          month = log.month

          # Calculate the start and end dates for the pay periods
          start_date_first_half = Date.new(year, month, 1)
          end_date_first_half = Date.new(year, month, 15)

          start_date_second_half = Date.new(year, month, 16)
          end_date_second_half = start_date_second_half.end_of_month

          # Calculate the total hours worked in each half of the month
          total_hours_first_half = log.first_half_hours
          total_hours_second_half = log.second_half_hours

          # Calculate the amount paid for each half of the month based on the hourly rate and total hours
          amount_paid_first_half = hourly_rate * total_hours_first_half
          amount_paid_second_half = hourly_rate * total_hours_second_half

          # Add the pay periods to the payroll report
          payroll_report[employee_id] ||= []

          if amount_paid_first_half.positive?
            payroll_report[employee_id] << payroll_attrs(employee_id: employee_id, 
                                                         start_date:  start_date_first_half , 
                                                         end_date:    end_date_first_half  , 
                                                         amount_paid: amount_paid_first_half)

          end

          if amount_paid_second_half.positive?
            payroll_report[employee_id] << payroll_attrs(employee_id: employee_id, 
                                                         start_date:  start_date_second_half  , 
                                                         end_date:    end_date_second_half , 
                                                         amount_paid: amount_paid_second_half)

       
          end
        end

        payroll_report.values.flatten
    end


    def fetch_grouped_work_log
      WorkLog.joins(employee: :job_group)
                           .select('employees.employee_id,
                                    job_groups.hourly_rate,
                                    SUM(CASE WHEN DAY(work_logs.work_date) <= 15 THEN work_logs.hours_worked ELSE 0 END) AS first_half_hours,
                                    SUM(CASE WHEN DAY(work_logs.work_date) > 15 THEN work_logs.hours_worked ELSE 0 END) AS second_half_hours,
                                    YEAR(work_logs.work_date) AS year,
                                    MONTH(work_logs.work_date) AS month')
                           .group('employees.employee_id, YEAR(work_logs.work_date), MONTH(work_logs.work_date)')
    end

    def payroll_attrs(options)
      {
        employeeId: options[:employee_id],
        payPeriod: {
              startDate: date_format(options[:start_date]),
              endDate: date_format(options[:end_date])
          },
        amountPaid: currency_format(options[:amount_paid])
      }
    end

    def currency_format(amount)
      "$#{amount}"
    end

    def date_format(date)
      date.strftime('%Y-%m-%d')
    end

end
