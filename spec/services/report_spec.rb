require "rails_helper"

RSpec.describe Report do
  subject(:report) { described_class }

  describe "registered reports" do
    subject(:registered_reports) { described_class::REGISTERED_REPORTS }

    let(:expected_ids) do
      %i[home_office home_office_excel standing_data payroll applications qa]
    end

    let(:expected_classes) do
      [
        Reports::HomeOfficeCsv,
        Reports::HomeOfficeExcel,
        Reports::StandingData,
        Reports::Payroll,
        Reports::Applications,
        Reports::QaReport,
      ]
    end

    it { expect(registered_reports.keys).to match_array(expected_ids) }
    it { expect(registered_reports.values).to match_array(expected_classes) }
  end

  describe ".call" do
    subject(:service) { described_class.new(report_id, status:) }

    let(:report_id) { "qa" }
    let(:status) { "initial_checks" }

    context "report_name" do
      it { expect(service.name).to eq("reports-qa-report-initial_checks") }
    end

    context "filename" do
      include ActiveSupport::Testing::TimeHelpers
      it "returns the name of the Report" do
        frozen_time = Time.zone.local(2023, 7, 17, 12, 30, 45)
        travel_to frozen_time do
          expected_name = "reports-qa-report-initial_checks-20230717-123045.csv"

          expect(service.filename).to eq(expected_name)
        end
      end
    end

    # rubocop:disable RSpec/VerifiedDoubles
    context "qa report data" do
      let(:report) { spy(Reports::QaReport) }

      before do
        allow(Reports::QaReport).to receive(:new).and_return(report)
        service.data
      end

      it { expect(Reports::QaReport).to have_received(:new).with(status:) }
      it { expect(report).to have_received(:generate) }
    end

    context "home office csv report" do
      let(:report_id) { "home_office" }
      let(:report) { spy(Reports::HomeOfficeCsv) }

      before do
        allow(Reports::HomeOfficeCsv).to receive(:new).and_return(report)
        service.data
      end

      it { expect(Reports::HomeOfficeCsv).to have_received(:new) }
      it { expect(report).to have_received(:generate) }
    end

    context "home office excel report" do
      let(:report_id) { "home_office" }
      let(:report) { spy(Reports::HomeOfficeExcel) }

      before do
        Flipper.enable :home_office_excel
        allow(Reports::HomeOfficeExcel).to receive(:new).and_return(report)
        service.data
        Flipper.disable :home_office_excel
      end

      it { expect(Reports::HomeOfficeExcel).to have_received(:new) }
      it { expect(report).to have_received(:generate) }
    end
    # rubocop:enable RSpec/VerifiedDoubles
  end
end
