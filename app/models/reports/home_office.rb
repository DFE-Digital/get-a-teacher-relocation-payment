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
      Applicant.all.map do |applicant|
        [
          applicant.application.urn,
          applicant.given_name,
          applicant.family_name,
          applicant.date_of_birth,
          applicant.nationality,
          applicant.passport_number,
          applicant.application.visa_type,
          applicant.application.date_of_entry,
        ]
      end
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
