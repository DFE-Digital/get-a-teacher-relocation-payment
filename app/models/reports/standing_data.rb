# frozen_string_literal: true

module Reports
  class StandingData < Base
    def generate
      CSV.generate do |csv|
        csv << header
        rows.each { |row| csv << row }
      end
    end

    def post_generation_hook
      applications.update_all(standing_data_csv_downloaded_at: Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
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
        "applicants.student_loan",
      )
    end

    def applications
      @applications ||= Application
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
        Middle_name
        Surname
        Telephone
        Email
        Address
        Postcode
        Student_loan
      ]
    end
  end
end
