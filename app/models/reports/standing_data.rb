# frozen_string_literal: true

module Reports
  class StandingData
    def name
      current_time = Time.zone.now.strftime("%Y%m%d-%H%M%S")

      "Standing-Data-Report-#{current_time}.csv"
    end

    def csv
      csv_file = CSV.generate do |csv|
        csv << header
        rows.each { |row| csv << row }
      end
      applications.update_all(standing_data_csv_downloaded_at: Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
      csv_file
    end

  private

    def rows
      applications.pluck(
        "urn",
        "given_name",
        "middle_name",
        "family_name",
        Arel.sql("CONCAT('tel: ', applicants.phone_number)"),
        "email_address",
        "address_line_1",
        "postcode",
      )
    end

    def applications
      Application
        .joins(:application_progress)
        .joins(applicant: :address)
        .where.not(application_progresses: { school_checks_completed_at: nil })
        .where(
          application_progresses: {
            banking_approval_completed_at: nil,
            rejection_completed_at: nil,
          },
          standing_data_csv_downloaded_at: nil,
        )
    end

    def header
      %w[
        URN
        Forename
        Middle
        Name
        Surname
        Telephone
        Email
        Address
        Postcode
      ]
    end
  end
end
