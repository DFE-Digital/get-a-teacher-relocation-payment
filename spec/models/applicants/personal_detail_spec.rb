# frozen_string_literal: true

require "rails_helper"

module Applicants
  describe PersonalDetail do
    let(:params) { {} }
    let(:application) { create(:application, :not_submitted, applicant: nil) }

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
      it { is_expected.to validate_presence_of(:postcode) }

      it {
        expect(model).to validate_inclusion_of(:sex)
                           .in_array(Applicants::PersonalDetail::SEX_OPTIONS)
      }

      include_examples "a valid UK postcode", described_class
      include_examples "validates phone number with international prefix", described_class, :phone_number
      describe "date_of_birth minimum age" do
        subject { model.errors.messages_for(:date_of_birth) }
        let(:model) { described_class.new(params) }
        let(:minimun_age) { 22 }
        let(:params) do
          {
            day: age.day.to_s,
            month: age.month.to_s,
            year: age.year.to_s,
          }
        end

        before { model.valid? }

        context "invalid when younger than minimun age" do
          let(:age) { minimun_age.years.ago + 1.day }

          it { is_expected.to be_present }
        end

        context "valid when exactly the minimun age" do
          let(:age) { minimun_age.years.ago }

          it { is_expected.to be_blank }
        end

        context "valid when older than minimun age" do
          let(:age) { minimun_age.years.ago - 1.day }

          it { is_expected.to be_blank }
        end
      end

      describe "#applicant=" do
        let(:applicant) do
          create(:applicant,
                 given_name: "John",
                 family_name: "Smith",
                 email_address: "john.gmail.com",
                 phone_number: "07777777777",
                 date_of_birth: Date.new(2020, 3, 30),
                 sex: "male",
                 passport_number: "123456789",
                 nationality: "Spanish",
                 address: build(:address,
                                address_line_1: "1 High Street",
                                address_line_2: "Flat 1",
                                city: "London",
                                postcode: "SW1A 1AA"))
        end

        subject(:model) { described_class.new(applicant:) }

        it "loads the applicant's personal details" do
          expect(model).to have_attributes(
            given_name: "John",
            family_name: "Smith",
            email_address: "john.gmail.com",
            phone_number: "07777777777",
            sex: "male",
            passport_number: "123456789",
            nationality: "Spanish",
          )
        end

        it "loads the applicant's date of birth" do
          expect(model).to have_attributes(
            day: 30,
            month: 3,
            year: 2020,
          )
        end

        it "loads the applicant's address" do
          expect(model).to have_attributes(
            address_line_1: "1 High Street",
            address_line_2: "Flat 1",
            city: "London",
            postcode: "SW1A 1AA",
          )
        end
      end

      describe "save!" do
        let(:params) do
          {
            given_name: "John",
            family_name: "Smith",
            email_address: "john@email.com",
            phone_number: "07777777777",
            day: "01",
            month: "01",
            year: "2000",
            sex: "Male",
            passport_number: "123456789",
            nationality: "British",
            address_line_1: "1 High Street",
            address_line_2: "Flat 1",
            city: "London",
            postcode: "SW1A 1AA",
          }
        end

        subject(:model) { described_class.new(params) }

        it "creates an applicant" do
          expect { model.save!(application:) }.to change(Applicant, :count).by(1)
        end

        it "creates an address" do
          expect { model.save!(application:) }.to change(Address, :count).by(1)
        end

        it "links the address and the applicant" do
          model.save!(application:)

          expect(Applicant.last.address).to eq(Address.last)
        end

        it "returns an applicant" do
          expect(model.save!(application:)).to be_a(Applicant)
        end
      end

      describe "date_of_birth" do
        context "when date_of_birth is invalid" do
          let(:params) { { day: "31", month: "02", year: "2000" } }

          it "is invalid" do
            model.valid?

            expect(model.errors["date_of_birth"]).not_to be_blank
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
