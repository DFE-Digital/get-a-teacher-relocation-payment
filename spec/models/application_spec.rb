# == Schema Information
#
# Table name: applications
#
#  id                              :bigint           not null, primary key
#  application_date                :date
#  application_route               :string
#  date_of_entry                   :date
#  home_office_csv_downloaded_at   :datetime
#  payroll_csv_downloaded_at       :datetime
#  standing_data_csv_downloaded_at :datetime
#  start_date                      :date
#  subject                         :string
#  urn                             :string
#  visa_type                       :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  applicant_id                    :bigint
#
# Foreign Keys
#
#  fk_rails_...  (applicant_id => applicants.id)
#
require "rails_helper"

RSpec.describe Application do
  describe "validations" do
    context "when the application has been submitted" do
      subject(:application) { build(:teacher_application, :submitted) }

      it { expect(application).to validate_presence_of(:application_date) }
      it { expect(application).to validate_presence_of(:application_route) }
      it { expect(application).to validate_presence_of(:date_of_entry) }
      it { expect(application).to validate_presence_of(:start_date) }
      it { expect(application).to validate_presence_of(:subject) }
      it { expect(application).to validate_presence_of(:visa_type) }
      it { expect(application).to validate_presence_of(:applicant) }
    end

    context "when the application has not been submitted" do
      it "is valid" do
        expect(described_class.new).to be_valid
      end
    end
  end

  describe "scopes" do
    describe ".submitted" do
      it "returns applications with a URN" do
        create_list(:application, 2, :submitted)
        create(:application, :not_submitted)

        expect(described_class.submitted.count).to eq 2
      end

      it "does not return applications without a URN" do
        create(:application, :not_submitted)

        expect(described_class.submitted.count).to eq 0
      end
    end

    describe ".filter_by_status" do
      it "returns applications with the specified status" do
        initial_checks_application = build(:application)
        create(:application_progress, :initial_checks_completed, application: initial_checks_application, status: :initial_checks)

        home_office_checks_application = build(:application)
        create(:application_progress, :home_office_checks_completed, application: home_office_checks_application, status: :home_office_checks)

        filtered_applications = described_class.filter_by_status("home_office_checks")

        expect(filtered_applications).to contain_exactly(initial_checks_application)
      end

      it "returns all applications if status is blank" do
        initial_checks_application = build(:application)
        create(:application_progress, application: initial_checks_application, status: :initial_checks)

        home_office_checks_application = build(:application)
        create(:application_progress, application: home_office_checks_application, status: :home_office_checks)

        filtered_applications = described_class.filter_by_status("")

        expect(filtered_applications).to contain_exactly(initial_checks_application, home_office_checks_application)
      end
    end
  end

  describe "#urn" do
    it "is blank before creation" do
      application = described_class.new

      expect(application.urn).to be_blank
    end
  end

  describe "#assign_urn!" do
    it "matches the required format for a teacher" do
      application = create(:teacher_application)
      application.assign_urn!

      expect(application.reload.urn).to match(/^IRPTE[A-Z0-9]{5}$/)
    end

    it "matches the required format for a trainee" do
      application = create(:salaried_trainee_application)
      application.assign_urn!

      expect(application.reload.urn).to match(/^IRPST[A-Z0-9]{5}$/)
    end
  end

  describe ".search" do
    let(:applicant_john) { create(:applicant, given_name: "John", family_name: "Doe", email_address: "john.doe@example.com", passport_number: "123456") }
    let(:application_john) { create(:application, urn: "APP123", applicant: applicant_john) }
    let(:applicant_jane) { create(:applicant, given_name: "Jane", family_name: "Doe", email_address: "jane.doe@example.com", passport_number: "7891011") }
    let(:application_jane) { create(:application, urn: "APP456", applicant: applicant_jane) }

    context "when searching by urn" do
      it "returns applications with matching urn", :aggregate_failures do
        expect(described_class.search("APP123")).to include(application_john)
        expect(described_class.search("APP123")).not_to include(application_jane)
      end
    end

    context "when searching by email address" do
      it "returns applications for applicants with matching email address", :aggregate_failures do
        expect(described_class.search("john.doe@example.com")).to include(application_john)
        expect(described_class.search("john.doe@example.com")).not_to include(application_jane)
      end
    end

    context "when searching by passport number" do
      it "returns applications for applicants with matching passport number", :aggregate_failures do
        expect(described_class.search("123456")).to include(application_john)
        expect(described_class.search("123456")).not_to include(application_jane)
      end
    end

    context "when searching by full name" do
      it "returns applications for applicants with matching full name", :aggregate_failures do
        expect(described_class.search("John Doe")).to include(application_john)
        expect(described_class.search("John Doe")).not_to include(application_jane)
      end
    end

    context "when searching by given name" do
      it "returns applications for applicants with matching given name", :aggregate_failures do
        expect(described_class.search("John")).to include(application_john)
        expect(described_class.search("John")).not_to include(application_jane)
      end
    end

    context "when searching by family name" do
      it "returns applications for applicants with matching family name" do
        expect(described_class.search("Doe")).to include(application_john, application_jane)
      end
    end

    context "when searching with case insensitive" do
      it "returns applications for applicants with case insensitive matching", :aggregate_failures do
        expect(described_class.search("jOhN DoE")).to include(application_john)
        expect(described_class.search("jOhN DoE")).not_to include(application_jane)
      end
    end

    context "when search term is empty" do
      it "returns all applications" do
        expect(described_class.search("")).to include(application_john, application_jane)
      end
    end
  end

  describe "#qa?" do
    let(:application) { create(:application) }

    context "when there is no QA status with the specified status" do
      it "returns false" do
        expect(application).not_to be_qa
      end
    end

    context "when there is a QA status with the specified status" do
      before do
        application.mark_as_qa!
      end

      it "returns true" do
        expect(application).to be_qa
      end
    end
  end

  describe "#mark_as_qa!" do
    let(:application) { create(:application) }

    it "adds a new QA status with the specified status" do
      expect {
        application.mark_as_qa!
      }.to change { application.qa_statuses.count }.by(1)

      expect(application.qa_statuses.last.status).to eq(application.status)
    end

    it "sets the date of the new QA status to the current date" do
      current_date = Date.current
      allow(Date).to receive(:current).and_return(current_date)

      application.mark_as_qa!

      expect(application.qa_statuses.last.date).to eq(current_date)
    end
  end
end
