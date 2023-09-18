# frozen_string_literal: true

module Reports
  class HomeOffice
    def name
      current_time = Time.zone.now.strftime("%Y%m%d-%H%M%S")

      "Home-Office-Report-#{current_time}.csv"
    end

    def csv
      csv_file = CSV.generate do |csv|
        csv << header
        rows.each { |row| csv << row }
      end
      applications.update_all(home_office_csv_downloaded_at: Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
      csv_file
    end

  private

    def rows
      applications.map do |application|
        [
          application.urn,
          application.applicant.full_name,
          application.applicant.date_of_birth,
          application.applicant.nationality,
          application.applicant.passport_number,
          nil,
          nil,
        ]
      end
    end

    def applications
      Application
        .joins(:application_progress)
        .includes(:applicant)
        .where.not(application_progresses: { initial_checks_completed_at: nil })
        .where(
          application_progresses: {
            home_office_checks_completed_at: nil,
            rejection_completed_at: nil,
          },
          home_office_csv_downloaded_at: nil,
        )
    end

    def header
      [
        "URN",
        "Full Name",
        "DOB",
        "Nationality",
        "Passport Number",
        "Visa Type",
        "Date of UK entry",
      ]
    end
  end
end
