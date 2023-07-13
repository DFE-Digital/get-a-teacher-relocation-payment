# frozen_string_literal: true

module Reports
  class Payroll
    def name
      "Payroll-Report.csv"
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
        "urn",
        "given_name",
        "family_name",
        "date_of_birth",
        "sex",
        "email_address",
        "address_line_1",
        "postcode",
        "phone_number",
      )
    end

    def candidates
      Application
        .joins(:application_progress)
        .joins(applicant: :address)
        .where.not(application_progresses: { banking_approval_completed_at: nil })
    end

    def header
      %w[
        URN
        Forename
        Surname
        DOB
        Gender
        Email
        Address
        Postcode
        Telephone
      ]
    end
  end
end
