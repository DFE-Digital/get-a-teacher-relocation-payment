require "rails_helper"

module Reports
  describe Applications do
    include ActiveSupport::Testing::TimeHelpers

    subject(:report) { described_class.new }

    it "returns the filename of the Report" do
      frozen_time = Time.zone.local(2023, 7, 17, 12, 30, 45)
      travel_to frozen_time do
        expected_name = "reports-applications-20230717-123045.csv"

        report = described_class.new
        actual_name = report.filename

        expect(actual_name).to eq(expected_name)
      end
    end

    describe "#csv" do
      let(:rejected) { create(:application, :with_rejection_completed) }
      let(:paid) { create(:application, :with_payment_confirmation_completed) }
      let(:banking) { create(:application, :with_banking_approval_completed) }
      let(:school) { create(:application, :with_school_checks_completed) }
      let(:home_office) { create(:application, :with_home_office_checks_completed) }
      let(:initial) { create(:application, :with_initial_checks_completed) }
      let(:application) { create(:application) }

      before do
        rejected
        paid
        banking
        school
        home_office
        initial
        application
      end

      context "returns file with header" do
        let(:header) do
          [
            "Urn",
            "Given Name",
            "Middle Name",
            "Family Name",
            "Email Address",
            "Phone Number",
            "Date Of Birth",
            "Sex",
            "Passport Number",
            "Nationality",
            "Student Loan",
            "Address Line 1",
            "Address Line 2",
            "City",
            "Postcode",
            "Application Date",
            "Application Route",
            "Status",
            "Date Of Entry",
            "Start Date",
            "Subject",
            "Visa Type",
            "Rejection Reason",
            "Ip Address",
            "School Name",
            "School Headteacher",
            "School Address Line 1",
            "School Address Line 2",
            "School City",
            "School Postcode",
          ].join(",")
        end

        it { expect(report.generate).to include(header) }
      end

      context "returns all applications" do
        it { expect(report.generate).to include(application.urn) }
        it { expect(report.generate).to include(initial.urn) }
        it { expect(report.generate).to include(home_office.urn) }
        it { expect(report.generate).to include(school.urn) }
        it { expect(report.generate).to include(banking.urn) }
        it { expect(report.generate).to include(paid.urn) }
        it { expect(report.generate).to include(rejected.urn) }
      end

      it "generates correct data" do
        csv = CSV.parse(report.generate, headers: true)

        expect(csv[6]["School Name"]).to eql(application.applicant.school.name)
        expect(csv[6]["School Headteacher"]).to eql(application.applicant.school.headteacher_name)
        expect(csv[6]["School Address Line 1"]).to eql(application.applicant.school.address.address_line_1)
        expect(csv[6]["School Address Line 2"]).to eql(application.applicant.school.address.address_line_2)
        expect(csv[6]["School City"]).to eql(application.applicant.school.address.city)
        expect(csv[6]["School Postcode"]).to eql(application.applicant.school.address.postcode)
      end
    end
  end
end
