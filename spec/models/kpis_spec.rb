require "rails_helper"

RSpec.describe Kpis do
  subject(:kpis) { described_class.new(unit:, range_start:, range_end:) }

  let(:unit) { "hours" }
  let(:range_start) { "12" }
  let(:range_end) { "0" }

  let(:application) { create(:application) }

  describe "argument error on initialize" do
    context "when unknown unit" do
      let(:unit) { "bad" }

      it { expect { kpis }.to raise_error(ArgumentError) }
    end

    context "when bad range_start and range_end" do
      let(:range_start) { "bad" }
      let(:range_end) { "bad" }

      it { expect { kpis }.to raise_error(ArgumentError) }
    end

    context "when range_start negative" do
      let(:range_start) { "-15" }

      it { expect { kpis }.to raise_error(ArgumentError) }
    end

    context "when range_end negative" do
      let(:range_end) { "-15" }

      it { expect { kpis }.to raise_error(ArgumentError) }
    end

    context "when range_end value greater than range_start" do
      let(:range_start) { "15" }
      let(:range_end) { "24" }

      it { expect { kpis }.to raise_error(ArgumentError) }
    end
  end

  describe "#total_applications" do
    before do
      create_list(:application, 3, created_at: Date.new(2023, 9, 15))
      create_list(:application, 2, created_at: Date.new(2024, 1, 15))
    end

    context "when window is 'all'" do
      subject(:kpis) { described_class.new(window: "all") }

      it "returns total number of applications" do
        expect(kpis.total_applications).to eq(5)
      end
    end

    context "when window is 'sept_oct'" do
      subject(:kpis) { described_class.new(window: "sept_oct") }

      it "returns total number of applications created within 'sept_oct' window" do
        expect(kpis.total_applications).to eq(3)
      end
    end

    context "when window is 'jan_feb'" do
      subject(:kpis) { described_class.new(window: "jan_feb") }

      it "returns total number of applications created within 'jan_feb' window" do
        expect(kpis.total_applications).to eq(2)
      end
    end
  end

  describe "#total_rejections" do
    before do
      create_list(:application_progress, 3, :rejection_completed, application: create(:application), created_at: Date.new(2023, 9, 15))
      create_list(:application_progress, 2, :rejection_completed, application: create(:application), created_at: Date.new(2024, 1, 15))
    end

    context "when window is 'all'" do
      subject(:kpis) { described_class.new(window: "all") }

      it "returns total number of rejections" do
        expect(kpis.total_rejections).to eq(5)
      end
    end

    context "when window is 'sept_oct'" do
      subject(:kpis) { described_class.new(window: "sept_oct") }

      it "returns total number of rejections created within 'sept_oct' window" do
        expect(kpis.total_rejections).to eq(3)
      end
    end

    context "when window is 'jan_feb'" do
      subject(:kpis) { described_class.new(window: "jan_feb") }

      it "returns total number of rejections created within 'jan_feb' window" do
        expect(kpis.total_rejections).to eq(2)
      end
    end
  end

  describe "#average_age" do
    before do
      create(:application, applicant: create(:applicant, date_of_birth: 35.years.ago), created_at: Date.new(2023, 9, 15))
      create(:application, applicant: create(:applicant, date_of_birth: 45.years.ago), created_at: Date.new(2023, 9, 20))
      create(:application, applicant: create(:applicant, date_of_birth: 52.years.ago), created_at: Date.new(2024, 1, 15))
    end

    context "when window is 'all'" do
      subject(:kpis) { described_class.new(window: "all") }

      it "returns the average age of all applications" do
        expect(kpis.average_age).to eq(44)
      end
    end

    context "when window is 'sept_oct'" do
      subject(:kpis) { described_class.new(window: "sept_oct") }

      it "returns the average age of applications created in 'sept_oct' window" do
        expect(kpis.average_age).to eq(40) # Average of first two applicants (35 and 45)
      end
    end

    context "when window is 'jan_feb'" do
      subject(:kpis) { described_class.new(window: "jan_feb") }

      it "returns the average age of applications created within 'jan_feb' window" do
        expect(kpis.average_age).to eq(52) # Only one applicant in this date range (52)
      end
    end
  end

  describe "#total_paid" do
    before do
      create(:application_progress, :banking_approval_completed, application: create(:application), created_at: Date.new(2023, 9, 15))
      create(:application_progress, :banking_approval_completed, application: create(:application), created_at: Date.new(2024, 1, 15))
    end

    context "when window is 'all'" do
      subject(:kpis) { described_class.new(window: "all") }

      it "returns total number of paid applications" do
        expect(kpis.total_paid).to eq(2)
      end
    end

    context "when window is 'sept_oct'" do
      subject(:kpis) { described_class.new(window: "sept_oct") }

      it "returns total number of paid applications" do
        total = kpis.total_paid
        expect(total).to eq(1)
        sept_oct_payment = ApplicationProgress.where("extract(month from created_at) IN (?) AND banking_approval_completed_at IS NOT NULL", [9, 10]).last
        expect(sept_oct_payment).to be_present
      end
    end

    context "when window is 'jan_feb'" do
      subject(:kpis) { described_class.new(window: "jan_feb") }

      it "returns total number of paid applications" do
        total = kpis.total_paid
        expect(total).to eq(1)
        jan_feb_payment = ApplicationProgress.where("extract(month from created_at) IN (?) AND banking_approval_completed_at IS NOT NULL", [1, 2]).last
        expect(jan_feb_payment).to be_present
      end
    end
  end

  describe "#route_breakdown" do
    before do
      create_list(:teacher_application, 3, created_at: Date.new(2023, 9, 15))
      create_list(:salaried_trainee_application, 2, created_at: Date.new(2024, 1, 15))
    end

    context "when window is 'all'" do
      subject(:kpis) { described_class.new(window: "all") }

      it "returns a breakdown of all application routes" do
        expect(kpis.route_breakdown).to eq({ "teacher" => 3, "salaried_trainee" => 2 })
      end
    end

    context "when window is 'sept_oct'" do
      subject(:kpis) { described_class.new(window: "sept_oct") }

      it "returns a breakdown of application routes created within 'sept_oct' window" do
        expect(kpis.route_breakdown).to eq({ "teacher" => 3 })
      end
    end

    context "when window is 'jan_feb'" do
      subject(:kpis) { described_class.new(window: "jan_feb") }

      it "returns a breakdown of application routes created within 'jan_feb' window" do
        expect(kpis.route_breakdown).to eq({ "salaried_trainee" => 2 })
      end
    end
  end

  describe "#subject_breakdown" do
    before do
      create_list(:application, 3, subject: :physics, created_at: Date.new(2023, 9, 15))
      create_list(:application, 2, subject: :languages, created_at: Date.new(2024, 1, 15))
      create(:application, subject: :general_science, created_at: Date.new(2024, 1, 16))
    end

    context "when window is 'all'" do
      subject(:kpis) { described_class.new(window: "all") }

      it "returns a breakdown of all application subjects" do
        expect(kpis.subject_breakdown).to eq({ "physics" => 3, "languages" => 2, "general_science" => 1 })
      end
    end

    context "when window is 'sept_oct'" do
      subject(:kpis) { described_class.new(window: "sept_oct") }

      it "returns a breakdown of application subjects created within 'sept_oct' window" do
        expect(kpis.subject_breakdown).to eq({ "physics" => 3 })
      end
    end

    context "when window is 'jan_feb'" do
      subject(:kpis) { described_class.new(window: "jan_feb") }

      it "returns a breakdown of application subjects created within 'jan_feb' window" do
        expect(kpis.subject_breakdown).to eq({ "languages" => 2, "general_science" => 1 })
      end
    end
  end

  describe "#visa_breakdown" do
    before do
      create_list(:application, 3, visa_type: "visa_1", created_at: Date.new(2023, 9, 15))
      create_list(:application, 2, visa_type: "visa_2", created_at: Date.new(2023, 9, 15))
      create(:application, visa_type: "visa_3", created_at: Date.new(2024, 1, 15))
    end

    context "when window is 'all'" do
      subject(:kpis) { described_class.new(window: "all") }

      it "returns a breakdown of all application visas" do
        expect(kpis.visa_breakdown).to contain_exactly(["visa_1", 3], ["visa_2", 2], ["visa_3", 1])
      end
    end

    context "when window is 'sept_oct'" do
      subject(:kpis) { described_class.new(window: "sept_oct") }

      it "returns a breakdown of application visas created within 'sept_oct' window" do
        expect(kpis.visa_breakdown).to contain_exactly(["visa_1", 3], ["visa_2", 2])
      end
    end

    context "when window is 'jan_feb'" do
      subject(:kpis) { described_class.new(window: "jan_feb") }

      it "returns a breakdown of application visas created within 'jan_feb' window" do
        expect(kpis.visa_breakdown).to contain_exactly(["visa_3", 1])
      end
    end
  end

  describe "#nationality_breakdown" do
    before do
      create_list(:application, 3, applicant: create(:applicant, nationality: "Nationality 1"), created_at: Date.new(2023, 9, 15))
      create(:application, applicant: create(:applicant, nationality: "Nationality 2"), created_at: Date.new(2023, 9, 15))
      create_list(:application, 2, applicant: create(:applicant, nationality: "Nationality 3"), created_at: Date.new(2024, 1, 15))
    end

    context "when window is 'all'" do
      subject(:kpis) { described_class.new(window: "all") }

      it "returns a breakdown of all application nationalities" do
        expect(kpis.nationality_breakdown).to contain_exactly(["Nationality 1", 3], ["Nationality 2", 1], ["Nationality 3", 2])
      end
    end

    context "when window is 'sept_oct'" do
      subject(:kpis) { described_class.new(window: "sept_oct") }

      it "returns a breakdown of application nationalities within 'sept_oct' window" do
        expect(kpis.nationality_breakdown).to contain_exactly(["Nationality 1", 3], ["Nationality 2", 1])
      end
    end

    context "when window is 'jan_feb'" do
      subject(:kpis) { described_class.new(window: "jan_feb") }

      it "returns a breakdown of application nationalities within 'jan_feb' window" do
        expect(kpis.nationality_breakdown).to contain_exactly(["Nationality 3", 2])
      end
    end
  end

  describe "#gender_breakdown" do
    before do
      create_list(:application, 3, applicant: create(:applicant, sex: "male"), created_at: Date.new(2023, 9, 15))
      create(:application, applicant: create(:applicant, sex: "female"), created_at: Date.new(2023, 9, 15))
      create(:application, applicant: create(:applicant, sex: "female"), created_at: Date.new(2024, 1, 15))
    end

    context "when window is 'all'" do
      subject(:kpis) { described_class.new(window: "all") }

      it "returns a breakdown of all application genders" do
        expect(kpis.gender_breakdown).to contain_exactly(["male", 3], ["female", 2])
      end
    end

    context "when window is 'sept_oct'" do
      subject(:kpis) { described_class.new(window: "sept_oct") }

      it "returns a breakdown of application genders within 'sept_oct' window" do
        expect(kpis.gender_breakdown).to contain_exactly(["male", 3], ["female", 1])
      end
    end

    context "when window is 'jan_feb'" do
      subject(:kpis) { described_class.new(window: "jan_feb") }

      it "returns a breakdown of application genders within 'jan_feb' window" do
        expect(kpis.gender_breakdown).to contain_exactly(["female", 1])
      end
    end
  end

  describe "#rejection_reason_breakdown" do
    before do
      applicant = create(:applicant)
      create_list(:application_progress, 2, application: create(:application, applicant: applicant, created_at: Date.new(2023, 9, 15)), rejection_reason: "suspected_fraud")
      create(:application_progress, application: create(:application, applicant: applicant, created_at: Date.new(2023, 9, 15)), rejection_reason: "ineligible_school")
      create(:application_progress, application: create(:application, applicant: applicant, created_at: Date.new(2024, 1, 15)), rejection_reason: "ineligible_school")
    end

    context "when window is 'all'" do
      subject(:kpis) { described_class.new(window: "all") }

      it "returns a breakdown of all application rejection reasons" do
        expect(kpis.rejection_reason_breakdown).to contain_exactly(["suspected_fraud", 2], ["ineligible_school", 2])
      end
    end

    context "when window is 'sept_oct'" do
      subject(:kpis) { described_class.new(window: "sept_oct") }

      it "returns a breakdown of application rejection reasons within 'sept_oct' window" do
        expect(kpis.rejection_reason_breakdown).to contain_exactly(["suspected_fraud", 2], ["ineligible_school", 1])
      end
    end

    context "when window is 'jan_feb'" do
      subject(:kpis) { described_class.new(window: "jan_feb") }

      it "returns a breakdown of application rejection reasons within 'jan_feb' window" do
        expect(kpis.rejection_reason_breakdown).to contain_exactly(["ineligible_school", 1])
      end
    end
  end

  describe "#time_to_initial_checks" do
    before do
      create(:application_progress, :initial_checks_completed,
             application: create(:application, created_at: Date.new(2023, 9, 10)),
             created_at: Date.new(2023, 9, 10),
             initial_checks_completed_at: Date.new(2023, 9, 15))

      create(:application_progress, :initial_checks_completed,
             application: create(:application, created_at: Date.new(2023, 9, 10)),
             created_at: Date.new(2023, 9, 10),
             initial_checks_completed_at: Date.new(2023, 9, 15))

      create(:application_progress, :initial_checks_completed,
             application: create(:application, created_at: Date.new(2024, 1, 10)),
             created_at: Date.new(2024, 1, 10),
             initial_checks_completed_at: Date.new(2024, 1, 15))
    end

    context "when window is 'all'" do
      subject(:kpis) { described_class.new(window: "all") }

      it "returns min, max and average time to initial checks for all applications" do
        result = kpis.time_to_initial_checks

        expect(result[:min]).to eq "5 days"
        expect(result[:max]).to eq "5 days"
        expect(result[:average]).to eq "5 days"
      end
    end

    context "when window is 'sept_oct'" do
      subject(:kpis) { described_class.new(window: "sept_oct") }

      it "returns min, max and average time to initial checks for applications in 'sept_oct' window" do
        result = kpis.time_to_initial_checks

        expect(result[:min]).to eq "5 days"
        expect(result[:max]).to eq "5 days"
        expect(result[:average]).to eq "5 days"
      end
    end

    context "when window is 'jan_feb'" do
      subject(:kpis) { described_class.new(window: "jan_feb") }

      it "returns min, max and average time to initial checks for applications in 'jan_feb' window" do
        result = kpis.time_to_initial_checks

        expect(result[:min]).to eq "5 days"
        expect(result[:max]).to eq "5 days"
        expect(result[:average]).to eq "5 days"
      end
    end
  end

  describe "#time_to_home_office_checks" do
    before do
      create(:application_progress, :home_office_checks_completed,
             application: create(:application, created_at: Date.new(2023, 9, 10)),
             created_at: Date.new(2023, 9, 10),
             initial_checks_completed_at: Date.new(2023, 9, 15),
             home_office_checks_completed_at: Date.new(2023, 9, 21))

      create(:application_progress, :home_office_checks_completed,
             application: create(:application, created_at: Date.new(2023, 9, 10)),
             created_at: Date.new(2023, 9, 10),
             initial_checks_completed_at: Date.new(2023, 9, 15),
             home_office_checks_completed_at: Date.new(2023, 9, 25))

      create(:application_progress, :home_office_checks_completed,
             application: create(:application, created_at: Date.new(2024, 1, 10)),
             created_at: Date.new(2024, 1, 10),
             initial_checks_completed_at: Date.new(2024, 1, 15),
             home_office_checks_completed_at: Date.new(2024, 1, 20))
    end

    context "when window is 'all'" do
      subject(:kpis) { described_class.new(window: "all") }

      it "returns min, max and average time to home office checks for all applications" do
        result = kpis.time_to_home_office_checks

        expect(result[:min]).to eq "5 days"
        expect(result[:max]).to eq "10 days"
        expect(result[:average]).to eq "7 days"
      end
    end

    context "when window is 'sept_oct'" do
      subject(:kpis) { described_class.new(window: "sept_oct") }

      it "returns min, max and average time to home office checks for applications in 'sept_oct' window" do
        result = kpis.time_to_home_office_checks

        expect(result[:min]).to eq "6 days"
        expect(result[:max]).to eq "10 days"
        expect(result[:average]).to eq "8 days"
      end
    end

    context "when window is 'jan_feb'" do
      subject(:kpis) { described_class.new(window: "jan_feb") }

      it "returns min, max and average time to home office checks for applications in 'jan_feb' window" do
        result = kpis.time_to_home_office_checks

        expect(result[:min]).to eq "5 days"
        expect(result[:max]).to eq "5 days"
        expect(result[:average]).to eq "5 days"
      end
    end
  end

  describe "#time_to_school_checks" do
    before do
      create(:application_progress, :school_checks_completed,
             application: create(:application, created_at: Date.new(2023, 9, 10)),
             created_at: Date.new(2023, 9, 10),
             home_office_checks_completed_at: Date.new(2023, 9, 15),
             school_checks_completed_at: Date.new(2023, 9, 20))

      create(:application_progress, :school_checks_completed,
             application: create(:application, created_at: Date.new(2023, 9, 10)),
             created_at: Date.new(2023, 9, 10),
             home_office_checks_completed_at: Date.new(2023, 9, 15),
             school_checks_completed_at: Date.new(2023, 9, 25))

      create(:application_progress, :school_checks_completed,
             application: create(:application, created_at: Date.new(2024, 1, 10)),
             created_at: Date.new(2024, 1, 10),
             home_office_checks_completed_at: Date.new(2024, 1, 15),
             school_checks_completed_at: Date.new(2024, 1, 25))
    end

    context "when window is 'all'" do
      subject(:kpis) { described_class.new(window: "all") }

      it "returns min, max and average time to school checks for all applications" do
        result = kpis.time_to_school_checks

        expect(result[:min]).to eq "5 days"
        expect(result[:max]).to eq "10 days"
        expect(result[:average]).to eq "8 days"
      end
    end

    context "when window is 'sept_oct'" do
      subject(:kpis) { described_class.new(window: "sept_oct") }

      it "returns min, max and average time to school checks for applications in 'sept_oct' window" do
        result = kpis.time_to_school_checks
        expect(result[:min]).to eq "5 days"
        expect(result[:max]).to eq "10 days"
        expect(result[:average]).to eq "8 days"
      end
    end

    context "when window is 'jan_feb'" do
      subject(:kpis) { described_class.new(window: "jan_feb") }

      it "returns min, max and average time to school checks for applications in 'jan_feb' window" do
        result = kpis.time_to_school_checks

        expect(result[:min]).to eq "10 days"
        expect(result[:max]).to eq "10 days"
        expect(result[:average]).to eq "10 days"
      end
    end
  end

  describe "#time_to_banking_approval" do
    before do
      sept_oct_school_check = Date.new(2023, 9, 27)
      jan_feb_school_check = Date.new(2024, 1, 20)

      create(:application_progress, :banking_approval_completed,
             application: create(:application, created_at: sept_oct_school_check),
             created_at: sept_oct_school_check,
             school_checks_completed_at: sept_oct_school_check,
             banking_approval_completed_at: sept_oct_school_check + 5.days)

      create(:application_progress, :banking_approval_completed,
             application: create(:application, created_at: sept_oct_school_check),
             created_at: sept_oct_school_check,
             school_checks_completed_at: sept_oct_school_check,
             banking_approval_completed_at: sept_oct_school_check + 7.days)

      create(:application_progress, :banking_approval_completed,
             application: create(:application, created_at: jan_feb_school_check),
             created_at: jan_feb_school_check,
             school_checks_completed_at: jan_feb_school_check,
             banking_approval_completed_at: jan_feb_school_check + 10.days)
    end

    context "when window is 'all'" do
      subject(:kpis) { described_class.new(window: "all") }

      it "returns min, max and average time to banking approval for all applications" do
        result = kpis.time_to_banking_approval

        expect(result[:min]).to eq "5 days"
        expect(result[:max]).to eq "10 days"
        expect(result[:average]).to eq "7 days"
      end
    end

    context "when window is 'sept_oct'" do
      subject(:kpis) { described_class.new(window: "sept_oct") }

      it "returns min, max and average time to banking approval for applications in 'sept_oct' window" do
        result = kpis.time_to_banking_approval

        expect(result[:min]).to eq "5 days"
        expect(result[:max]).to eq "7 days"
        expect(result[:average]).to eq "6 days"
      end
    end

    context "when window is 'jan_feb'" do
      subject(:kpis) { described_class.new(window: "jan_feb") }

      it "returns min, max and average time to banking approval for applications in 'jan_feb'" do
        result = kpis.time_to_banking_approval

        expect(result[:min]).to eq "10 days"
        expect(result[:max]).to eq "10 days"
        expect(result[:average]).to eq "10 days"
      end
    end
  end

  describe "#time_to_payment_confirmation" do
    before do
      sept_oct_banking_approval = Date.new(2023, 9, 27)
      jan_feb_banking_approval = Date.new(2024, 1, 20)

      create(:application_progress, :payment_confirmation_completed,
             application: create(:application, created_at: sept_oct_banking_approval),
             created_at: sept_oct_banking_approval,
             banking_approval_completed_at: sept_oct_banking_approval,
             payment_confirmation_completed_at: sept_oct_banking_approval + 5.days)

      create(:application_progress, :payment_confirmation_completed,
             application: create(:application, created_at: sept_oct_banking_approval),
             created_at: sept_oct_banking_approval,
             banking_approval_completed_at: sept_oct_banking_approval,
             payment_confirmation_completed_at: sept_oct_banking_approval + 7.days)

      create(:application_progress, :payment_confirmation_completed,
             application: create(:application, created_at: jan_feb_banking_approval),
             created_at: jan_feb_banking_approval,
             banking_approval_completed_at: jan_feb_banking_approval,
             payment_confirmation_completed_at: jan_feb_banking_approval + 10.days)
    end

    context "when window is 'all'" do
      subject(:kpis) { described_class.new(window: "all") }

      it "returns min, max and average time to payment confirmation for all applications" do
        result = kpis.time_to_payment_confirmation

        expect(result[:min]).to eq "5 days"
        expect(result[:max]).to eq "10 days"
        expect(result[:average]).to eq "7 days"
      end
    end

    context "when window is 'sept_oct'" do
      subject(:kpis) { described_class.new(window: "sept_oct") }

      it "returns min, max and average time to payment confirmation for applications in 'sept_oct' window" do
        result = kpis.time_to_payment_confirmation

        expect(result[:min]).to eq "5 days"
        expect(result[:max]).to eq "7 days"
        expect(result[:average]).to eq "6 days"
      end
    end

    context "when window is 'jan_feb'" do
      subject(:kpis) { described_class.new(window: "jan_feb") }

      it "returns min, max and average time to payment confirmation for applications in 'jan_feb' window" do
        result = kpis.time_to_payment_confirmation

        expect(result[:min]).to eq "10 days"
        expect(result[:max]).to eq "10 days"
        expect(result[:average]).to eq "10 days"
      end
    end
  end

  describe "#status_breakdown" do
    context "when window is 'all'" do
      subject(:kpis) { described_class.new(window: "all") }

      before do
        create(:application_progress, :initial_checks_completed,
               application: build(:application),
               created_at: Date.new(2023, 9, 10))
        create(:application_progress, :home_office_checks_completed,
               application: build(:application),
               created_at: Date.new(2024, 1, 5))
      end

      let(:expected_breakdown) do
        {
          "initial_checks" => 0,
          "home_office_checks" => 1,
          "school_checks" => 1,
          "bank_approval" => 0,
          "payment_confirmation" => 0,
          "paid" => 0,
          "rejected" => 0,
        }
      end

      it "returns the ordered application status breakdown" do
        result = kpis.status_breakdown

        expect(result).to include(expected_breakdown)
      end
    end

    context "when window is 'sept_oct'" do
      subject(:kpis) { described_class.new(window: "sept_oct") }

      before do
        create(:application_progress, :initial_checks_completed,
               application: build(:application),
               created_at: Date.new(2023, 9, 10))
        create(:application_progress, :home_office_checks_completed,
               application: build(:application),
               created_at: Date.new(2024, 1, 5))
      end

      let(:expected_breakdown) do
        {
          "initial_checks" => 0,
          "home_office_checks" => 1,
          "school_checks" => 0,
          "bank_approval" => 0,
          "payment_confirmation" => 0,
          "paid" => 0,
          "rejected" => 0,
        }
      end

      it "returns the ordered application status breakdown for applications in 'sept_oct' window" do
        result = kpis.status_breakdown

        expect(result).to include(expected_breakdown)
      end
    end

    context "when window is 'jan_feb'" do
      subject(:kpis) { described_class.new(window: "jan_feb") }

      before do
        create(:application_progress, :initial_checks_completed,
               application: build(:application),
               created_at: Date.new(2023, 9, 10))
        create(:application_progress, :home_office_checks_completed,
               application: build(:application),
               created_at: Date.new(2024, 1, 5))
      end

      let(:expected_breakdown) do
        {
          "initial_checks" => 0,
          "home_office_checks" => 0,
          "school_checks" => 1,
          "bank_approval" => 0,
          "payment_confirmation" => 0,
          "paid" => 0,
          "rejected" => 0,
        }
      end

      it "returns the ordered application status breakdown for applications in 'jan_feb' window" do
        result = kpis.status_breakdown

        expect(result).to include(expected_breakdown)
      end
    end
  end

  describe "funnel_date_range_title" do
    context "when range_end is set to 0" do
      let(:range_end) { 0 }

      it { expect(kpis.funnel_date_range_title).to eq("last 12 hours") }
    end

    context "when range_end is not 0" do
      let(:range_end) { 6 }

      it { expect(kpis.funnel_date_range_title).to eq("between 12 and 6 hours ago") }
    end
  end
end
