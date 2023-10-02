module Reports
  class Applications < Base
    def csv
      CSV.generate do |csv|
        csv << header
        rows.find_each(batch_size: 50) { |row| csv << columns(row) }
      end
    end

  private

    def header
      %i[
        urn
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
        visa_type
        rejection_reason
        ip_address
      ].map { _1.to_s.titleize }
    end

    def columns(application)
      applicant = application.applicant
      [
        application.urn,
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
        application.visa_type,
        application.application_progress.rejection_reason,
        applicant.ip_address,
      ]
    end

    def rows
      Application.includes(:applicant, :application_progress, applicant: :address)
    end
  end
end
