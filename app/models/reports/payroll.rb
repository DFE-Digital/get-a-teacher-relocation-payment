# frozen_string_literal: true

module Reports
  class Payroll < Base
    def generate
      CSV.generate do |csv|
        csv << header
        rows.each { |row| csv << row }
      end
    end

    def post_generation_hook
      applications.update_all(payroll_csv_downloaded_at: Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
    end

    def reset
      Application
        .where(payroll_csv_downloaded_at: timestamp_range)
        .update_all(payroll_csv_downloaded_at: nil) # rubocop:disable Rails/SkipsModelValidations
    end

  private

    def rows
      applications.pluck(
        "given_name",
        "family_name",
        "sex",
        "date_of_birth",
        "email_address",
        "address_line_1",
        "address_line_2",
        "city",
        "postcode",
      ).map do |row|
        Array.new(34, nil).tap do |array|
          array[1] = "Prof"
          array[2] = row[0]
          array[4] = row[1]
          array[6] = row[2]
          array[7] = "Other"
          array[10] = row[3]
          array[11] = row[4]
          array[12] = row[5]
          array[13] = row[6]
          array[14] = row[7]
          array[17] = row[8]
          array[18] = "United Kingdom"
          array[19] = "BR"
          array[20] = "0"
          array[24] = "Direct BACS"
          array[25] = "Weekly"
          array[30] = 10_000
          array[32] = "Get an International Relocation Payment"
          array[33] = "2"
        end
      end
    end

    def applications
      @applications ||= Application
        .joins(:application_progress)
        .joins(applicant: :address)
        .where.not(application_progresses: { banking_approval_completed_at: nil })
        .where(payroll_csv_downloaded_at: nil)
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
        CITY
        ADDR_LINE_4
        ADDR_LINE_5
        POSTCODE
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
