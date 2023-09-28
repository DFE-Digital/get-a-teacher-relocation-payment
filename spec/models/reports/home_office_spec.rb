# frozen_string_literal: true

require "rails_helper"

module Reports
  describe HomeOffice do
    include ActiveSupport::Testing::TimeHelpers

    subject(:report) { described_class.new }

    it "returns the filename of the Report" do
      frozen_time = Time.zone.local(2023, 7, 17, 12, 30, 45)
      travel_to frozen_time do
        expected_name = "reports-home-office-20230717-123045.csv"

        report = described_class.new
        actual_name = report.filename

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
        application = create(:application, application_progress: build(:application_progress, :home_office_pending))

        expect(report.csv).to include([
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
        ].join(","))
      end

      it "returns the header in CSV format" do
        expected_header = [
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
        ].join(",")

        expect(report.csv).to include(expected_header)
      end

      context "includes applications from the csv before invoking `post_generation_hook`" do
        let(:app) { create(:application, application_progress: build(:application_progress, :home_office_pending)) }
        let(:csv) { report.csv }

        before { app }

        it { expect(csv).to include(app.urn) }

        context "excludes applications from the csv after invoking `post_generation_hook`" do
          before { report.post_generation_hook }

          it { expect(csv).not_to include(app.urn) }
        end
      end
    end
  end
end
