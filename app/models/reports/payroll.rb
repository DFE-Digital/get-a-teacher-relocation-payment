# frozen_string_literal: true

module Reports
  class Payroll
    def name
      current_time = Time.zone.now.strftime("%Y%m%d-%H%M%S")

      "Payroll-Report-#{current_time}.csv"
    end

    def csv
      CSV.generate do |csv|
        csv << header
        rows.each { |row| csv << row }
      end
    end

  private

    def rows
      candidates.pluck(
        "given_name",
        "family_name",
        "sex",
        "date_of_birth",
        "email_address",
        "address_line_1",
        "address_line_2",
      ).map do |row|
        Array.new(34, nil).tap do |array|
          array[2] = row[0]
          array[4] = row[1]
          array[6] = row[2]
          array[10] = row[3]
          array[11] = row[4]
          array[12] = row[5]
          array[13] = row[6]
          array[18] = "United Kingdom"
        end
      end
    end

    def candidates
      Application
        .joins(:application_progress)
        .joins(applicant: :address)
        .where.not(application_progresses: { banking_approval_completed_at: nil })
    end

    def header
      %w[
        No.
        TITLE
        FORENAME
        FORENAME2
        SURNAME
        SS_NO
        GENDER
        MARITAL_STATUS
        START_DATE
        END_DATE
        BIRTH_DATE
        EMAIL
        ADDR_LINE_1
        ADDR_LINE_2
        ADDR_LINE_3
        ADDR_LINE_4
        ADDR_LINE_5
        ADDR_LINE_6
        ADDRESS_COUNTRY
        TAX_CODE
        TAX_BASIS
        NI_CATEGORY
        CON_STU_LOAN_I
        PLAN_TYPE
        PAYMENT_METHOD
        PAYMENT_FREQUENCY
        BANK_NAME
        SORT_CODE
        ACCOUNT_NUMBER
        ROLL_NUMBER
        SCHEME_AMOUNT
        PAYMENT_ID
        CLAIM_POLICIES
        RIGHT_TO_WORK_CONFIRM_STATUS
      ]
    end
  end
end
