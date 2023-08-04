# frozen_string_literal: true

require "rails_helper"

# rubocop:disable Metrics/ExampleLength
module Reports
  describe Payroll do
    include ActiveSupport::Testing::TimeHelpers

    subject(:report) { described_class.new }

    it "returns the name of the Report" do
      frozen_time = Time.zone.local(2023, 7, 17, 12, 30, 45)
      travel_to frozen_time do
        expected_name = "Payroll-Report-20230717-123045.csv"

        report = described_class.new
        actual_name = report.name

        expect(actual_name).to eq(expected_name)
      end
    end

    describe "#csv" do
      let(:progress) { build(:application_progress, banking_approval_completed_at: Time.zone.now) }

      it "returns applicants who have banking details approved" do
        app = create(:application, application_progress: progress)

        expect(report.csv).to include(app.applicant.family_name)
      end

      it "does not return applicants who have not the bankind details approved" do
        progress.banking_approval_completed_at = nil
        app = create(:application, application_progress: progress)

        expect(report.csv).not_to include(app.urn)
      end

      it "returns the data in CSV format" do
        application = create(:application, application_progress: progress)

        expect(report.csv).to include([
          "", # No.
          "Prof", # TITLE
          application.applicant.given_name, # FORENAME
          "", # FORENAME2
          application.applicant.family_name, # SURNAME
          "", # SS_NO
          application.applicant.sex, # GENDER
          "Other", # MARITAL_STATUS
          "", # START_DATE
          "", # END_DATE
          application.applicant.date_of_birth, # BIRTH_DATE
          application.applicant.email_address, # EMAIL
          application.applicant.address.address_line_1, # ADDR_LINE_1
          application.applicant.address.address_line_2, # ADDR_LINE_2
          "", # ADDR_LINE_3
          "", # ADDR_LINE_4
          "", # ADDR_LINE_5
          "", # ADDR_LINE_6
          "United Kingdom", # ADDRESS_COUNTRY
          "BR", # TAX_CODE
          "0", # TAX_BASIS
          "", # NI_CATEGORY
          "", # CON_STU_LOAN_I
          "", # PLAN_TYPE
          "Direct BACS", # PAYMENT_METHOD
          "Weekly", # PAYMENT_FREQUENCY
          "", # BANK_NAME
          "", # SORT_CODE
          "", # ACCOUNT_NUMBER
          "", # ROLL_NUMBER
          10_000, # SCHEME_AMOUNT
          "", # PAYMENT_ID
          "Get an International Relocation Payment", # CLAIM_POLICIES
          "2", # RIGHT_TO_WORK_CONFIRM_STATUS
        ].join(","))
      end

      it "returns the header in CSV format" do
        expected_header = %w[
          No.
          TITLE
          FORENAME
          FORENAME2
          SURNAME
          SS_NO
          GENDER
          MARITAL_STATUS
          START_DATE
          END_DATE
          BIRTH_DATE
          EMAIL
          ADDR_LINE_1
          ADDR_LINE_2
          ADDR_LINE_3
          ADDR_LINE_4
          ADDR_LINE_5
          ADDR_LINE_6
          ADDRESS_COUNTRY
          TAX_CODE
          TAX_BASIS
          NI_CATEGORY
          CON_STU_LOAN_I
          PLAN_TYPE
          PAYMENT_METHOD
          PAYMENT_FREQUENCY
          BANK_NAME
          SORT_CODE
          ACCOUNT_NUMBER
          ROLL_NUMBER
          SCHEME_AMOUNT
          PAYMENT_ID
          CLAIM_POLICIES
          RIGHT_TO_WORK_CONFIRM_STATUS
        ].join(",")

        expect(report.csv).to include(expected_header)
      end
    end
  end
end
# rubocop:enable Metrics/ExampleLength
