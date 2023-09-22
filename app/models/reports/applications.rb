module Reports
  class Applications
    def name
      current_time = Time.zone.now.strftime("%Y%m%d-%H%M%S")

      "Applications-Report-#{current_time}.csv"
    end

    def csv
      CSV.generate do |csv|
        csv << header
        rows.find_each(batch_size: 50) { |row| csv << columns(row) }
      end
    end

  private

    def header
      %i[
        ip_address
        given_name
        middle_name
        family_name
        email_address
        phone_number
        date_of_birth
        sex
        passport_number
        nationality
        student_loan
        address_line_1
        address_line_2
        city
        postcode
        application_date
        application_route
        status
        date_of_entry
        start_date
        subject
        urn
        visa_type
      ].map { _1.to_s.titleize }
    end

    def columns(application)
      applicant = application.applicant
      [
        applicant.ip_address,
        applicant.given_name,
        applicant.middle_name,
        applicant.family_name,
        applicant.email_address,
        applicant.phone_number,
        applicant.date_of_birth,
        applicant.sex,
        applicant.passport_number,
        applicant.nationality,
        applicant.student_loan,
        applicant.address.address_line_1,
        applicant.address.address_line_2,
        applicant.address.city,
        applicant.address.postcode,
        application.application_date,
        application.application_route,
        application.status,
        application.date_of_entry,
        application.start_date,
        application.subject,
        application.urn,
        application.visa_type,
      ]
    end

    def rows
      Application.includes(:applicant, :application_progress, applicant: :address)
    end
  end
end
