# frozen_string_literal: true

module Reports
  class StandingData
    def name
      "Standing-Data-Report.csv"
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
        "phone_number",
        "email_address",
        "address_line_1",
        "postcode",
      )
    end

    def candidates
      Application
        .joins(:application_progress)
        .joins(applicant: :address)
        .where.not(application_progresses: { school_checks_completed_at: nil })
        .where(application_progresses: { banking_approval_completed_at: nil })
    end

    def header
      %w[
        URN
        Forename
        Surname
        Telephone
        Email
        Address
        Postcode
      ]
    end
  end
end
