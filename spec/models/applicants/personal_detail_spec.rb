# frozen_string_literal: true

require "rails_helper"

module Applicants
  describe PersonalDetail do
    let(:params) { {} }

    subject(:model) { described_class.new(params) }

    describe "validations" do
      it { is_expected.to validate_presence_of(:given_name) }
      it { is_expected.to validate_presence_of(:family_name) }
      it { is_expected.to validate_presence_of(:email_address) }
      it { is_expected.to validate_presence_of(:phone_number) }
      it { is_expected.to validate_presence_of(:sex) }
      it { is_expected.to validate_presence_of(:passport_number) }
      it { is_expected.to validate_presence_of(:nationality) }
      it { is_expected.to validate_presence_of(:address_line_1) }
      it { is_expected.not_to validate_presence_of(:address_line_2) }
      it { is_expected.to validate_presence_of(:city) }
      it { is_expected.not_to validate_presence_of(:county) }
      it { is_expected.to validate_presence_of(:postcode) }

      it {
        expect(model).to validate_inclusion_of(:sex)
                           .in_array(Applicants::PersonalDetail::SEX_OPTIONS)
      }

      describe "postcode validation" do
        it "accepts valid postcodes" do
          model.postcode = "SW1A 1AA"
          model.valid?

          expect(model.errors[:postcode]).to be_empty
        end

        it "rejects invalid postcodes" do
          model.postcode = "Invalid postcode"
          model.valid?

          expect(model.errors[:postcode]).to include("Enter a valid postcode (for example, BN1 1AA)")
        end
      end

      describe "date_of_birth" do
        context "when date_of_birth is invalid" do
          let(:params) { { day: "31", month: "02", year: "2000" } }

          it "is invalid" do
            expect(model).not_to be_valid
          end
        end

        context "when date_of_birth is the future" do
          let(:params) { { day: Date.tomorrow.day, month: Date.tomorrow.month, year: Date.tomorrow.year } }

          it "is invalid" do
            expect(model).not_to be_valid
          end
        end

        context "when age is over 80 years old" do
          let(:params) { { day: "01", month: "01", year: 81.years.ago.year } }

          it "is invalid" do
            expect(model).not_to be_valid
          end
        end

        context "when date_of_birth is valid" do
          let(:params) { { day: "01", month: "01", year: "2000" } }

          it "is valid" do
            model.valid?

            expect(model.errors["date_of_birth"]).to be_blank
          end
        end
      end
    end
  end
end
