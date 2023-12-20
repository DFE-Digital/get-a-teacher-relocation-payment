require "rails_helper"

RSpec.describe Form::EligibilityCheck do
  subject(:check) { described_class.new(form) }

  let(:form) { build(:form) }

  describe "failure_reason" do
    context "when eligible" do
      let(:form) { build(:form, :eligible) }

      it { expect(check.failure_reason).to be_nil }
    end

    context "in the Jan/Feb 2024 window" do
      before do
        travel_to Time.zone.local(2024, 1, 2)
        AppSettings.current.update!(
          service_start_date: Time.zone.today,
          service_end_date: 1.month.from_now.end_of_month,
        )
        travel_to Time.zone.local(2024, 2, 29)
      end

      let(:form) { build(:form, :eligible) }

      context "when the contract start date is September 2023" do
        let(:form) do
          build(:form, :eligible,
                start_date: Date.new(2023, 9, 2),
                date_of_entry: Date.new(2023, 9, 2))
        end

        it { expect(check.failure_reason).to be_nil }
      end

      context "when the contract start date is Jan 2024" do
        let(:form) do
          build(:form, :eligible,
                start_date: Date.new(2024, 1, 1),
                date_of_entry: Date.new(2024, 1, 1))
        end

        it { expect(check.failure_reason).to be_nil }
      end

      context "when the contract start date is July 2023" do
        let(:form) do
          build(:form, :eligible,
                start_date: Date.new(2023, 7, 1),
                date_of_entry: Date.new(2023, 7, 1))
        end

        it { expect(check.failure_reason).to be_nil }
      end

      context "when the contract start date is June 2023" do
        let(:form) do
          build(:form, :eligible,
                start_date: Date.new(2023, 6, 30),
                date_of_entry: Date.new(2023, 6, 30))
        end
        let(:expected) { "contract must start within the last six months" }

        it { expect(check.failure_reason).to eq(expected) }
      end
    end

    context "in the Apr/May 2024 window" do
      before do
        travel_to Time.zone.local(2024, 4, 1)
        AppSettings.current.update!(
          service_start_date: Time.zone.today,
          service_end_date: 1.month.from_now.end_of_month,
        )
        travel_to Time.zone.local(2024, 5, 31)
        ENV["CONTRACT_START_MONTHS_LIMIT"] = "5"
      end

      after do
        ENV.delete("CONTRACT_START_MONTHS_LIMIT")
      end

      let(:form) { build(:form, :eligible) }

      context "when the contract start date is September 2023" do
        let(:form) do
          build(:form, :eligible,
                start_date: Date.new(2023, 9, 30),
                date_of_entry: Date.new(2023, 9, 30))
        end
        let(:expected) { "contract must start within the last five months" }

        it { expect(check.failure_reason).to eq(expected) }
      end

      context "when the contract start date is October 2023" do
        let(:form) do
          build(:form, :eligible,
                start_date: Date.new(2023, 10, 31),
                date_of_entry: Date.new(2023, 10, 31))
        end
        let(:expected) { "contract must start within the last five months"}

        it { expect(check.failure_reason).to eq(expected) }
      end

      context "when the contract start date is Jan 2024" do
        let(:form) do
          build(:form, :eligible,
                start_date: Date.new(2024, 1, 1),
                date_of_entry: Date.new(2024, 1, 1))
        end

        it { expect(check.failure_reason).to be_nil }
      end
    end

    context "when ineligible" do
      context "because of chosen application_route" do
        let(:form) { build(:form, application_route: "other") }
        let(:expected) { "application route other not accecpted" }

        it { expect(check.failure_reason).to eq(expected) }
      end

      context "because teacher has less than a year of experience" do
        let(:form) { build(:teacher_form, one_year: false) }
        let(:expected) { "teacher contract duration of less than one year not accepted" }

        it { expect(check.failure_reason).to eq(expected) }
      end

      context "because school is not state funded" do
        let(:form) { build(:form, state_funded_secondary_school: false) }
        let(:expected) { "school not state funded" }

        it { expect(check.failure_reason).to eq(expected) }
      end

      context "because of subject not accepted" do
        let(:form) { build(:form, subject: "other") }
        let(:expected) { "taught subject not accepted" }

        it { expect(check.failure_reason).to eq(expected) }
      end

      context "because of visa not accepted" do
        let(:form) { build(:form, visa_type: "Other") }
        let(:expected) { "visa not accepted" }

        it { expect(check.failure_reason).to eq(expected) }
      end

      context "because of start date too early" do
        let(:form) { build(:form, start_date: 8.months.ago) }
        let(:expected) { "contract must start within the last six months" }

        it { expect(check.failure_reason).to eq(expected) }
      end

      context "because of date of entry in the UK" do
        let(:form) do
          build(
            :form,
            start_date: 1.month.ago,
            date_of_entry: 5.months.ago,
          )
        end
        let(:expected) { "cannot enter the UK more than 3 months before your contract start date" }

        it { expect(check.failure_reason).to eq(expected) }
      end
    end
  end

  describe "passed?" do
    context "eligible form" do
      let(:form) { build(:form, :eligible) }

      it { expect(check).to be_passed }
    end

    context "ineligible form" do
      let(:form) { build(:form, application_route: "other") }

      it { expect(check).not_to be_passed }
    end
  end

  describe "failed?" do
    context "eligible form" do
      let(:form) { build(:form, :eligible) }

      it { expect(check).not_to be_failed }
    end

    context "ineligible form" do
      let(:form) { build(:form, application_route: "other") }

      it { expect(check).to be_failed }
    end
  end
end
