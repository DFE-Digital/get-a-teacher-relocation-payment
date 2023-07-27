# frozen_string_literal: true

require "rails_helper"

# rubocop:disable Metrics/ExampleLength
module Reports
  describe HomeOffice do
    include ActiveSupport::Testing::TimeHelpers

    subject(:report) { described_class.new }

    it "returns the name of the Report" do
      frozen_time = Time.zone.local(2023, 7, 17, 12, 30, 45)
      travel_to frozen_time do
        expected_name = "Home-Office-Report-20230717-123045.csv"

        report = described_class.new
        actual_name = report.name

        expect(actual_name).to eq(expected_name)
      end
    end

    describe "#csv" do
      it "returns applicants who have completed initial checks but not home office checks" do
        app = create(:application, application_progress: build(:application_progress, :home_office_pending))

        expect(report.csv).to include(app.urn)
      end

      it "does not return rejected applicants" do
        progress = build(:application_progress,
                         :home_office_pending,
                         rejection_completed_at: Time.zone.now)
        app = create(:application, application_progress: progress)

        expect(report.csv).not_to include(app.urn)
      end

      it "does not return applicants who have not completed initial checks" do
        app = create(:application, application_progress: build(:application_progress, initial_checks_completed_at: nil))

        expect(report.csv).not_to include(app.urn)
      end

      it "does not return applicants who have completed home office checks" do
        app = create(:application, application_progress: build(:application_progress, :initial_checks_completed, home_office_checks_completed_at: Time.zone.now))

        expect(report.csv).not_to include(app.urn)
      end

      it "returns the data in CSV format" do
        application = create(
          :application,
          application_progress: build(:application_progress, :home_office_pending),
        )

        expect(report.csv).to include([
          application.urn,
          application.applicant.full_name,
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
          "Full Name",
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
