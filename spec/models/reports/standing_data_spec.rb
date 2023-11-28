# frozen_string_literal: true

require "rails_helper"

module Reports
  describe StandingData do
    include ActiveSupport::Testing::TimeHelpers

    subject(:report) { described_class.new }

    let(:progress) { build(:application_progress, school_checks_completed_at: Time.zone.now, banking_approval_completed_at: nil) }

    it "returns the filename of the Report" do
      frozen_time = Time.zone.local(2023, 7, 17, 12, 30, 45)
      travel_to frozen_time do
        expected_name = "reports-standing-data-20230717-123045.csv"

        report = described_class.new
        actual_name = report.filename

        expect(actual_name).to eq(expected_name)
      end
    end

    describe "#generate" do
      let(:progress) { build(:application_progress, school_checks_completed_at: Time.zone.now, banking_approval_completed_at: nil) }

      it "returns applicants who have completed initial checks but not home office checks" do
        app = create(:application, application_progress: progress)

        expect(report.generate).to include(app.urn)
      end

      it "does not return rejected applicants" do
        progress.rejection_completed_at = Time.zone.now
        app = create(:application, application_progress: progress)

        expect(report.generate).not_to include(app.urn)
      end

      it "does not return applicants who have not completed initial checks" do
        progress.school_checks_completed_at = nil
        app = create(:application, application_progress: progress)

        expect(report.generate).not_to include(app.urn)
      end

      it "does not return applicants who have completed home office checks" do
        progress.banking_approval_completed_at = Time.zone.now
        app = create(:application, application_progress: progress)

        expect(report.generate).not_to include(app.urn)
      end

      # rubocop:disable RSpec/ExampleLength
      it "returns the data in CSV format" do
        application = create(:application, application_progress: progress)

        expect(report.generate).to include([
          application.urn,
          application.applicant.given_name,
          application.applicant.middle_name,
          application.applicant.family_name,
          "tel: #{application.applicant.phone_number}",
          application.applicant.email_address,
          application.applicant.address.address_line_1,
          application.applicant.address.postcode,
          application.applicant.student_loan,
        ].join(","))
      end

      it "returns the header in CSV format" do
        expected_header = %w[
          URN
          Forename
          Middle_name
          Surname
          Telephone
          Email
          Address
          Postcode
          Student_loan
        ].join(",")

        expect(report.generate).to include(expected_header)
      end

      context "includes applications from the csv before invoking `post_generation_hook`" do
        let(:app) { create(:application, application_progress: progress) }
        let(:csv) { report.generate }

        before { app }

        it { expect(csv).to include(app.urn) }

        context "excludes applications from the csv after invoking `post_generation_hook`" do
          before { report.post_generation_hook }

          it { expect(csv).not_to include(app.urn) }
        end
      end
    end
    # rubocop:enable RSpec/ExampleLength

    describe "reset" do
      let(:app) { create(:application, application_progress: progress) }

      before { app }

      it "allows previously downloaded applications in a report to be downloaded again" do
        travel_to(Time.zone.local(2023, 7, 17, 12, 30, 45)) do
          expect(report.generate).to include(app.urn)

          report.post_generation_hook

          described_class.new(timestamp: Time.zone.now.to_s).reset

          expect(report.generate).to include(app.urn)
        end
      end
    end
  end
end
