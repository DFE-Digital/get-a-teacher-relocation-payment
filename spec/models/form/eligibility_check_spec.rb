require "rails_helper"

RSpec.describe Form::EligibilityCheck do
  subject(:check) { described_class.new(form) }

  let(:form) { build(:form) }

  describe "failure_reason" do
    context "when eligible" do
      let(:form) { build(:form, :eligible) }

      it { expect(check.failure_reason).to be_nil }
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
        let(:form) { build(:form, start_date: Date.new(Date.current.year, 6, 30)) }
        let(:expected) { "contract must start after the first monday of July of this year" }

        it { expect(check.failure_reason).to eq(expected) }
      end

      context "because of date of entry in the UK" do
        let(:form) do
          build(
            :form,
            start_date: Date.new(Date.current.year, 8, 30),
            date_of_entry: Date.new(Date.current.year, 5, 29),
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
