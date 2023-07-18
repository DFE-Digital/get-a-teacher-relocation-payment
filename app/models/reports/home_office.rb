# frozen_string_literal: true

module Reports
  class HomeOffice
    def name
      current_time = Time.zone.now.strftime("%Y%m%d-%H%M%S")

      "Home-Office-Report-#{current_time}.csv"
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
        :urn,
        "applicants.given_name",
        "applicants.family_name",
        "applicants.date_of_birth",
        "applicants.nationality",
        "applicants.passport_number",
        :visa_type,
        :date_of_entry,
      )
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
