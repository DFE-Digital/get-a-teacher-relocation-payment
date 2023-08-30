# frozen_string_literal: true

require "rails_helper"

# rubocop:disable Metrics/ExampleLength
module Reports
  describe QaReport do
    include ActiveSupport::Testing::TimeHelpers

    subject(:report) { described_class.new(applications, status) }

    let(:applications) { [] }
    let(:status) { "submitted" }

    it "returns the name of the Report" do
      frozen_time = Time.zone.local(2023, 7, 17, 12, 30, 45)
      travel_to frozen_time do
        expected_name = "QA-Report-submitted-2023_07_17-12_30_45.csv"

        expect(report.name).to eq(expected_name)
      end
    end

    describe "#csv" do
      context "when the status is not 'rejected'" do
        it "returns the data in CSV format" do
          application = create(:application)
          applications << application

          expect(report.csv).to include([
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
            ].compact.join(",").prepend('"').concat('"'),
            application.visa_type,
            application.date_of_entry.strftime("%d/%m/%Y"),
          ].join(","))
        end
      end

      context "when the status is 'rejected'" do
        let(:status) { "rejected" }

        it "returns the data including rejection reasons in CSV format" do
          application = create(:application, application_progress: build(:application_progress, rejection_completed_at: Time.zone.now, status: :rejected, rejection_reason: :request_to_re_submit, rejection_details: "Some details"))
          applications << application

          expect(report.csv).to include([
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
            ].compact.join(",").prepend('"').concat('"'),
            application.visa_type,
            application.date_of_entry.strftime("%d/%m/%Y"),
            application.application_progress.rejection_reason&.humanize,
            application.application_progress.rejection_details,
          ].join(","))
        end
      end

      it "returns the header in CSV format" do
        expected_header = [
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
        expected_header += ["Rejection Reason", "Rejection Details"] if status == "rejected"

        expect(report.csv).to include(expected_header.join(","))
      end
    end
  end
end
# rubocop:enable Metrics/ExampleLength
