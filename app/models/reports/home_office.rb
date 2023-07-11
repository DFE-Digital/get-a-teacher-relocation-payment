# frozen_string_literal: true

module Reports
  class HomeOffice
    def name
      "Home-Office-Report.csv"
    end

    def csv
      CSV.generate do |csv|
        csv << header
        rows.each { |row| csv << row }
      end
    end

  private

    def rows
      candidates.all.map do |application|
        [
          application.urn,
          application.applicant.given_name,
          application.applicant.family_name,
          application.applicant.date_of_birth,
          application.applicant.nationality,
          application.applicant.passport_number,
          application.visa_type,
          application.date_of_entry,
        ]
      end
    end

    def candidates
      Application
        .joins(:application_progress)
        .joins(:applicant)
        .where.not(application_progresses: { initial_checks_completed_at: nil })
        .where(application_progresses: { home_office_checks_completed_at: nil })
    end

    def header
      [
        "URN",
        "Forename",
        "Surname",
        "DOB",
        "Nationality",
        "Passport Number",
        "Visa Type",
        "Date of UK entry",
      ]
    end
  end
end
