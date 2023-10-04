# frozen_string_literal: true

require "rails_helper"

module Reports
  describe HomeOffice do
    include ActiveSupport::Testing::TimeHelpers

    before { create(:mocked_home_office_report_template) }

    subject(:report) { described_class.new }

    let(:headers) { report.send(:worksheet)[0].cells.map(&:value) }

    it "returns the filename of the Report" do
      frozen_time = Time.zone.local(2023, 7, 17, 12, 30, 45)
      travel_to frozen_time do
        expected_name = "reports-home-office-20230717-123045.xlsx"

        report = described_class.new
        actual_name = report.filename

        expect(actual_name).to eq(expected_name)
      end
    end

    describe "cell_coords" do
      let(:cell_coords) { report.send(:cell_coords) }
      let(:app) { create(:application, application_progress: build(:application_progress, :home_office_pending)) }

      before { app }

      it "formats date field" do
        expect(cell_coords.first).to include(app.applicant.date_of_birth.to_s)
      end
    end

    describe "#dataset" do
      let(:dataset) { report.send(:dataset) }

      it "returns applicants who have completed initial checks but not home office checks" do
        app = create(:application, application_progress: build(:application_progress, :home_office_pending))
        expect(dataset.first).to include(app.urn)
      end

      it "does not return rejected applicants" do
        progress = build(:application_progress,
                         :home_office_pending,
                         rejection_completed_at: Time.zone.now)
        app = create(:application, application_progress: progress)

        expect(dataset).not_to include(app.urn)
      end

      it "does not return applicants who have not completed initial checks" do
        app = create(:application, application_progress: build(:application_progress, initial_checks_completed_at: nil))
        expect(dataset).not_to include(app.urn)
      end

      it "does not return applicants who have completed home office checks" do
        app = create(:application, application_progress: build(:application_progress, :initial_checks_completed, home_office_checks_completed_at: Time.zone.now))

        expect(dataset).not_to include(app.urn)
      end

      it "returns the data in CSV format" do
        application = create(:application, application_progress: build(:application_progress, :home_office_pending))

        expect(dataset).to contain_exactly([
          application.applicant.date_of_birth,
          application.applicant.nationality,
          application.urn,
          application.applicant.passport_number,
          application.applicant.full_name,
        ])
      end

      it "returns the header in CSV format" do
        expected_header = [
          "DOB",
          "Dummy 1",
          "Dummy 2",
          "Full Name/ Organisation Name",
          "ID (Mandatory)",
          "Nationality",
          "Passport Number",
        ]

        expect(headers).to match_array(expected_header)
      end

      context "includes applications from the csv before invoking `post_generation_hook`" do
        let(:app) { create(:application, application_progress: build(:application_progress, :home_office_pending)) }
        let(:dataset) { report.send(:dataset) }

        before { app }

        it { expect(dataset.first).to include(app.urn) }

        context "excludes applications from the csv after invoking `post_generation_hook`" do
          before { report.post_generation_hook }

          it { expect(dataset.first).to be_nil }
        end
      end
    end
  end
end
