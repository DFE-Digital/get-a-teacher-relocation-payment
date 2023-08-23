# == Schema Information
#
# Table name: forms
#
#  id                            :bigint           not null, primary key
#  address_line_1                :string
#  address_line_2                :string
#  application_route             :string
#  city                          :string
#  date_of_birth                 :date
#  date_of_entry                 :date
#  email_address                 :string
#  family_name                   :string
#  given_name                    :string
#  middle_name                   :string
#  nationality                   :string
#  one_year                      :boolean
#  passport_number               :string
#  phone_number                  :string
#  postcode                      :string
#  school_address_line_1         :string
#  school_address_line_2         :string
#  school_city                   :string
#  school_headteacher_name       :string
#  school_name                   :string
#  school_postcode               :string
#  sex                           :string
#  start_date                    :date
#  state_funded_secondary_school :boolean
#  student_loan                  :boolean
#  subject                       :string
#  visa_type                     :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
require "rails_helper"

RSpec.describe Form do
  subject(:form) { build(:form) }

  context "teacher" do
    subject(:form) { build(:teacher_form) }

    it { is_expected.to be_teacher_route }
    it { is_expected.not_to be_trainee_route }
  end

  context "trainee" do
    subject(:form) { build(:trainee_form) }

    it { is_expected.to be_trainee_route }
    it { is_expected.not_to be_teacher_route }
  end

  describe "eligibile?" do
    context "returns true when form eligible" do
      subject(:form) { build(:form, :eligible) }

      it { expect(form).to be_eligible }
    end

    context "returns false when form ineligible" do
      subject(:form) { build(:form, :eligible, application_route: "other") }

      it { expect(form).not_to be_eligible }
    end
  end

  describe "complete?" do
    context "returns true when form complete" do
      subject(:form) { build(:form, :complete) }

      it { expect(form).to be_complete }
    end

    context "returns false when form incomplete" do
      subject(:form) { build(:form, :complete, application_route: nil) }

      it { expect(form).not_to be_complete }
    end
  end

  describe "validate_eligibility" do
    before { form.validate_eligibility }

    context "does not add any error when eligible" do
      subject(:form) { build(:form, :eligible) }

      it { expect(form.errors).to be_blank }
    end

    context "adds an error when ineligible" do
      subject(:form) { build(:form, :eligible, application_route: "other") }

      it { expect(form.errors[:base]).not_to be_blank }
    end
  end

  describe "validate_completeness" do
    before { form.validate_completeness }

    context "does not add any error when complete" do
      subject(:form) { build(:form, :complete) }

      it { expect(form.errors).to be_blank }
    end

    context "adds an error when form incomplete" do
      subject(:form) { build(:form, :complete, application_route: nil) }

      it { expect(form.errors[:base]).not_to be_blank }
    end
  end

  describe "deconstruct_keys" do
    it { expect(form.deconstruct_keys(nil)).to eq(form.attributes.symbolize_keys) }
  end
end
