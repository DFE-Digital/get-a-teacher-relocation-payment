# frozen_string_literal: true

require "rails_helper"

# rubocop:disable Metrics/ExampleLength
module Reports
  describe HomeOffice do
    subject(:report) { described_class.new }

    it "returns the name of the Report" do
      expect(report.name).to eq("Home-Office-Report.csv")
    end

    describe "#csv" do
      it "returns applicants who have completed initial checks but not home office checks" do
        app = create(:application, application_progress: build(:application_progress, :home_office_pending))

        expect(report.csv).to include(app.urn)
      end

      it "does not return applicants who have not completed initial checks" do
        app = create(:application, application_progress: build(:application_progress, initial_checks_completed_at: nil))

        expect(report.csv).to_not include(app.urn)
      end

      it "does not return applicants who have completed home office checks" do
        app = create(:application, application_progress: build(:application_progress, :initial_checks_completed, home_office_checks_completed_at: Time.zone.now))

        expect(report.csv).to_not include(app.urn)
      end

      it "returns the data in CSV format" do
        application = create(
          :application,
          application_progress: build(:application_progress, :home_office_pending),
        )

        expect(report.csv).to include([
          application.urn,
          application.applicant.given_name,
          application.applicant.family_name,
          application.applicant.date_of_birth,
          application.applicant.nationality,
          application.applicant.passport_number,
          application.visa_type,
          application.date_of_entry,
        ].join(","))
      end

      it "returns the header in CSV format" do
        expected_header = [
          "URN",
          "Forename",
          "Surname",
          "DOB",
          "Nationality",
          "Passport Number",
          "Visa Type",
          "Date of UK entry",
        ].join(",")

        expect(report.csv).to include(expected_header)
      end
    end
  end
end
# rubocop:enable Metrics/ExampleLength
