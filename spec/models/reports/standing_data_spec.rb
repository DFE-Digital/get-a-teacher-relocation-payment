# frozen_string_literal: true

require "rails_helper"

module Reports
  describe StandingData do
    subject(:report) { described_class.new }

    it "returns the name of the Report" do
      expect(report.name).to eq("Standing-Data-Report.csv")
    end

    describe "#csv" do
      let(:progress) { build(:application_progress, school_checks_completed_at: Time.zone.now, banking_approval_completed_at: nil) }

      it "returns applicants who have completed initial checks but not home office checks" do
        app = create(:application, application_progress: progress)

        expect(report.csv).to include(app.urn)
      end

      it "does not return applicants who have not completed initial checks" do
        progress.school_checks_completed_at = nil
        app = create(:application, application_progress: progress)

        expect(report.csv).not_to include(app.urn)
      end

      it "does not return applicants who have completed home office checks" do
        progress.banking_approval_completed_at = Time.zone.now
        app = create(:application, application_progress: progress)

        expect(report.csv).not_to include(app.urn)
      end

      it "returns the data in CSV format" do
        application = create(:application, application_progress: progress)

        expect(report.csv).to include([
          application.urn,
          application.applicant.given_name,
          application.applicant.family_name,
          application.applicant.phone_number,
          application.applicant.email_address,
          application.applicant.address.address_line_1,
          application.applicant.address.postcode,
        ].join(","))
      end

      it "returns the header in CSV format" do
        expected_header = %w[
          URN
          Forename
          Surname
          Telephone
          Email
          Address
          Postcode
        ].join(",")

        expect(report.csv).to include(expected_header)
      end
    end
  end
end
