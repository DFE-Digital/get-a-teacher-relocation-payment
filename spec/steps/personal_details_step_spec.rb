require "rails_helper"

RSpec.describe PersonalDetailsStep, type: :model do
  subject(:step) { described_class.new(form) }

  let(:form) { build(:form) }

  include_examples "behaves like a step",
                   described_class,
                   route_key: "personal-details",
                   required_fields: %i[
                     email_address
                     family_name
                     given_name
                     phone_number
                     date_of_birth
                     address_line_1
                     city
                     postcode
                     sex
                     nationality
                     passport_number
                   ],
                   optional_fields: %i[middle_name address_line_2],
                   question: "Personal information",
                   question_type: :multi,
                   template: "step/personal_details"

  describe "additional validations" do
    it {
      expect(step).to validate_inclusion_of(:sex)
                         .in_array(described_class::SEX_OPTIONS)
    }

    describe "nationality" do
      it "validates allowed values" do
        expect(step).to validate_inclusion_of(:nationality).in_array(NATIONALITIES)
      end
    end

    describe "sex" do
      it "validates allowed values" do
        expect(step).to validate_inclusion_of(:sex).in_array(described_class::SEX_OPTIONS)
      end
    end

    describe "phone_number" do
      let(:form) { build(:form, phone_number:) }
      let(:error) { step.errors.messages_for(:phone_number) }

      before { step.valid? }

      context "valid" do
        [
          "07700900000", # UK number
          "07700 900 000", # UK number with spaces
          "07700 900-000", # UK number with hyphens
          "7700 900-000", # UK number without `0`
          "+447702909898", # UK number with country code
          "+44 0 7702 909 898", # UK number with country code, spaces and `0`
          "+44 (0)7702-909-898", # UK number with country code, spaces, and `(0)`
          "44 (0) 7702 909 898", # UK number with country code, spaces, `(0)` and no `+`
          "+34 985 256 634", # Spanish number (home) with spaces
          "+34 626577222", # Spanish number (mobile) without spaces
          "+34626577222", # Spanish number (mobile) without spaces and with country code
          "34 626-577-222", # Spanish number (mobile) with spaces and hyphens
        ].each do |number|
          let(:phone_number) { number }
          it "is valid for #{number}" do
            expect(error).to be_blank
          end
        end
      end

      context "invalid" do
        [
          "700900000", # UK number without `0` missing digit
          "700 900 000", # UK number without `0` with spaces missing digit
          "+347702909898", # Spanish number with country code extra digits
          "+34 0 7702 909 898", # Spanish number with country code and `0` as extra digit
          "+34 985 256", # spanish number (home) with spaces and missing digits
        ].each do |number|
          let(:phone_number) { number }
          it "is valid for #{number}" do
            expect(error).to be_present
          end
        end
      end
    end

    describe "postcode" do
      let(:form) { build(:form, postcode:) }
      let(:error) { step.errors.messages_for(:postcode) }

      before { step.valid? }

      context "valid" do
        let(:postcode) { "SW1A 1AA" }

        it { expect(error).to be_blank }
      end

      context "invalid" do
        let(:postcode) { "invalid" }

        it { expect(error).to be_present }
      end
    end

    describe "date_of_birth minimum age" do
      let(:form) { build(:form, date_of_birth: age) }
      let(:error) { step.errors.messages_for(:date_of_birth) }
      let(:minimun_age) { 22 }

      before { step.valid? }

      context "invalid when younger than minimun age" do
        let(:age) { minimun_age.years.ago + 1.day }

        it { expect(error).to be_present }
      end

      context "valid when exactly the minimun age" do
        let(:age) { minimun_age.years.ago }

        it { expect(error).to be_blank }
      end

      context "valid when older than minimun age" do
        let(:age) { minimun_age.years.ago - 1.day }

        it { expect(error).to be_blank }
      end
    end
  end
end