module Reports
  class HomeOfficeCsv < Base
    file_ext "csv"

    def generate
      CSV.generate do |csv|
        csv << header
        rows.each { |row| csv << row }
      end
    end

    def post_generation_hook
      applications.update_all(home_office_csv_downloaded_at: Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
    end

  private

    def rows
      applications.map do |application|
        [
          application.urn,
          application.applicant.full_name,
          application.applicant.date_of_birth,
          nil,
          application.applicant.nationality,
          nil,
          application.applicant.passport_number,
          nil,
          nil,
          nil,
          nil,
          nil,
          nil,
        ]
      end
    end

    def applications
      @applications ||= Application
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
        "ID",
        "Full Name",
        "DOB",
        "Gender",
        "Nationality",
        "Place of Birth",
        "Passport Number",
        "National Insurance Number",
        "Address",
        "Postcode",
        "Email",
        "Telephone",
        "Reference",
      ]
    end
  end
end
