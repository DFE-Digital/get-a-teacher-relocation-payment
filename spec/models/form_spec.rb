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
end
