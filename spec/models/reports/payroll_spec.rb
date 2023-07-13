# frozen_string_literal: true

require "rails_helper"

# rubocop:disable Metrics/ExampleLength
module Reports
  describe Payroll do
    subject(:report) { described_class.new }

    it "returns the name of the Report" do
      expect(report.name).to eq("Payroll-Report.csv")
    end

    describe "#csv" do
      let(:progress) { build(:application_progress, banking_approval_completed_at: Time.zone.now) }

      it "returns applicants who have banking details approved" do
        app = create(:application, application_progress: progress)

        expect(report.csv).to include(app.urn)
      end

      it "does not return applicants who have not the bankind details approved" do
        progress.banking_approval_completed_at = nil
        app = create(:application, application_progress: progress)

        expect(report.csv).not_to include(app.urn)
      end

      it "returns the data in CSV format" do
        application = create(:application, application_progress: progress)

        expect(report.csv).to include([
          application.urn,
          application.applicant.given_name,
          application.applicant.family_name,
          application.applicant.date_of_birth,
          application.applicant.sex,
          application.applicant.email_address,
          application.applicant.address.address_line_1,
          application.applicant.address.postcode,
          application.applicant.phone_number,
        ].join(","))
      end

      it "returns the header in CSV format" do
        expected_header = %w[
          URN
          Forename
          Surname
          DOB
          Gender
          Email
          Address
          Postcode
          Telephone
        ].join(",")

        expect(report.csv).to include(expected_header)
      end
    end
  end
end
# rubocop:enable Metrics/ExampleLength
