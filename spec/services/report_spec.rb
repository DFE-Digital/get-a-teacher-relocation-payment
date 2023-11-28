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
    subject(:service) { described_class.new(report_id, status:, user:, id:) }

    let(:report_id) { "qa" }
    let(:status) { "initial_checks" }
    let(:user) { build(:user) }
    let(:id) { report_id }

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

    context "auditing report download" do
      before do
        allow(Audited::Audit).to receive(:new).and_return(spy(Audited::Audit)) # rubocop:disable RSpec/VerifiedDoubles

        service.create_audit
      end

      let(:expected_params) do
        {
          action: "Downloaded #{service.name} report",
          user: user,
          comment: {
            resettable: true,
            id: report_id,
            status: status,
          }.to_json,
        }
      end

      it { expect(Audited::Audit).to have_received(:new).with(expected_params) }
    end

    context "auditing report reset" do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:audit) do
        create(
          :audit,
          action: "Downloaded #{service.name} report",
          user: user,
          comment: download_audit_comment_param.to_json,
        )
      end
      let(:expected_params) do
        {
          action: "Reset #{service.name} report",
          user: user,
        }
      end
      let(:download_audit_comment_param) do
        {
          resettable: true,
          id: report_id,
          status: status,
        }
      end

      before do
        audit
        s = described_class.new(
          report_id,
          status: status,
          user: user,
          id: id,
          arid: audit.id,
          timestamp: audit.created_at,
        )

        allow(Audited::Audit).to receive(:new).and_return(spy(Audited::Audit)) # rubocop:disable RSpec/VerifiedDoubles
        s.create_audit
      end

      it { expect(Audited::Audit).to have_received(:new).with(expected_params) }
    end

    # rubocop:disable RSpec/VerifiedDoubles
    context "qa report data" do
      let(:report) { spy(Reports::QaReport) }

      before do
        allow(Reports::QaReport).to receive(:new).and_return(report)
        service.data
      end

      it { expect(Reports::QaReport).to have_received(:new).with(id:, status:, user:) }
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
