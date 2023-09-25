require "rails_helper"

RSpec.describe Report do
  subject(:report) { described_class }

  describe "registered reports" do
    subject(:registered_reports) { described_class::REGISTERED_REPORTS }

    let(:expected_ids) do
      %i[home_office standing_data payroll applications qa]
    end

    let(:expected_classes) do
      [
        Reports::HomeOffice,
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
      it { expect(service.report_name).to eq("Reports::qareport") }
    end

    context "filename" do
      include ActiveSupport::Testing::TimeHelpers
      it "returns the name of the Report" do
        frozen_time = Time.zone.local(2023, 7, 17, 12, 30, 45)
        travel_to frozen_time do
          expected_name = "QA-Report-initial_checks-2023_07_17-12_30_45.csv"

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

      it { expect(Reports::QaReport).to have_received(:new).with(kind_of(Array), status) }
      it { expect(report).to have_received(:csv) }
    end

    context "other report data" do
      let(:report_id) { "home_office" }
      let(:report) { spy(Reports::HomeOffice) }

      before do
        allow(Reports::HomeOffice).to receive(:new).and_return(report)
        service.data
      end

      it { expect(Reports::HomeOffice).to have_received(:new) }
      it { expect(report).to have_received(:csv) }
    end
    # rubocop:enable RSpec/VerifiedDoubles
  end
end
