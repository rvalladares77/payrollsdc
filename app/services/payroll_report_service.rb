class PayrollReportService

  def generate
    generate_payroll_report
  end

  private

    def generate_payroll_report
      payroll_report = {}

      fetch_paid_periods.each do |log|
        employee_id             = log.employee_id
        hourly_rate             = log.hourly_rate
        year                    = log.year
        month                   = log.month
        amount_paid_first_half  = calculate_amount_paid(hourly_rate, log.first_half_hours)
        amount_paid_second_half = calculate_amount_paid(hourly_rate, log.second_half_hours)

        # Add the pay periods to the payroll report
        payroll_report[employee_id] ||= []

        if amount_paid_first_half.positive?
          payroll_report[employee_id] << payroll_attrs(employee_id: employee_id, 
                                                       dates:       dates_first_half(year, month),
                                                       amount_paid: amount_paid_first_half)
        end

        if amount_paid_second_half.positive?
          payroll_report[employee_id] << payroll_attrs(employee_id: employee_id, 
                                                       dates:       dates_second_half(year, month),  
                                                       amount_paid: amount_paid_second_half)
        end
      end

        payroll_report.values.flatten
    end


    def fetch_paid_periods
      WorkLog.
        joins(employee: :job_group).
        select('employees.employee_id,
                job_groups.hourly_rate,
                SUM(CASE WHEN DAY(work_logs.work_date) <= 15 THEN work_logs.hours_worked ELSE 0 END) AS first_half_hours,
                SUM(CASE WHEN DAY(work_logs.work_date) > 15 THEN work_logs.hours_worked ELSE 0 END) AS second_half_hours,
                YEAR(work_logs.work_date) AS year,
                MONTH(work_logs.work_date) AS month').
        group('employees.employee_id, YEAR(work_logs.work_date), MONTH(work_logs.work_date)')
    end

    def payroll_attrs(options)
      {
        employeeId: options[:employee_id],
        payPeriod: {
              startDate: date_format(options[:dates][:start_date]),
              endDate:   date_format(options[:dates][:end_date])
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

    def calculate_amount_paid(hours_workd, hourly_rate)
      hourly_rate * hours_workd
    end

    def dates_first_half(year, month)
      { start_date: Date.new(year, month, 1), end_date: Date.new(year, month, 15)}
    end

    def dates_second_half(year, month)
      { start_date: Date.new(year, month, 16), end_date: Date.new(year, month, 16).end_of_month}
    end

end
