module Reports
  class QaReport < Base
    def initialize(...)
      super(...)
      @name = [@name, status].join("-")
    end

    def csv
      CSV.generate do |csv|
        csv << header
        rows.each { |row| csv << row }
      end
    end

    def post_generation_hook
      applications.each(&:mark_as_qa!)
    end

    def status
      kwargs.fetch(:status)
    end

  private

    def applications
      @applications ||= Application
                          .includes(
                            :applicant,
                            :application_progress,
                            applicant: :address,
                          )
                          .filter_by_status(status)
                          .reject(&:qa?)
    end

    def rows
      applications.map do |application|
        [
          application.urn,
          application.applicant.full_name,
          application.applicant.date_of_birth.strftime("%d/%m/%Y"),
          application.applicant.nationality,
          application.applicant.passport_number,
          application.applicant.email_address,
          [
            application.applicant.address.address_line_1,
            application.applicant.address.address_line_2,
            application.applicant.address.city,
            application.applicant.address.postcode,
          ].compact.join(","),
          application.visa_type,
          application.date_of_entry.strftime("%d/%m/%Y"),
          rejection_rows(application),
        ].compact.flatten!
      end
    end

    def rejection_rows(app)
      return [] if status != "rejected"

      [
        app.application_progress.rejection_reason&.humanize,
        app.application_progress.comments,
      ]
    end

    def header
      headers = [
        "URN",
        "Full Name",
        "DOB",
        "Nationality",
        "Passport Number",
        "Email Address",
        "Full Address",
        "Visa Type",
        "Date of UK entry",
      ]
      headers.append(rejection_headers) if status == "rejected"
      headers.flatten
    end

    def rejection_headers
      ["Rejection Reason", "Rejection Details"]
    end
  end
end
