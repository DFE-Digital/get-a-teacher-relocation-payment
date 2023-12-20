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
FactoryBot.define do
  factory :form do
    application_route { %w[salaried_trainee teacher].sample }

    factory :teacher_form do
      application_route { "teacher" }
    end

    factory :trainee_form do
      application_route { "salaried_trainee" }
    end

    trait :eligible do
      state_funded_secondary_school { true }
      one_year { true }
      visa_type do
        [
          "Afghan Relocations and Assistance Policy",
          "Afghan citizens resettlement scheme",
          "British National (Overseas) visa",
          "Family visa",
          "High Potential Individual visa",
          "India Young Professionals Scheme visa",
          "Skilled worker visa",
          "UK Ancestry visa",
          "Ukraine Family Scheme visa",
          "Ukraine Sponsorship Scheme",
          "Youth Mobility Scheme",
        ].sample
      end
      start_date { 1.month.ago }
      date_of_entry { 1.month.ago }
      subject { "physics" }
    end

    trait :complete do
      state_funded_secondary_school { true }
      one_year { true }
      visa_type { "British National (Overseas) visa" }
      start_date { 1.month.ago }
      date_of_entry { 1.month.ago }
      subject { "physics" }
      date_of_birth { rand(18..90).years.ago.to_date }
      email_address { Faker::Internet.email }
      family_name { Faker::Name.last_name }
      given_name { Faker::Name.first_name }
      middle_name { Faker::Name.middle_name }
      phone_number { Faker::PhoneNumber.cell_phone_in_e164 }
      sex { %w[female male].sample }
      address_line_1 { Faker::Address.street_address }
      address_line_2 { Faker::Address.secondary_address }
      city { Faker::Address.city }
      postcode { Faker::Address.postcode }
      passport_number { Faker::Alphanumeric.alpha(number: 10) }
      nationality { NATIONALITIES.sample }
      student_loan { true }
      school_headteacher_name { Faker::Name.name }
      school_name { Faker::Educator.secondary_school }
      school_address_line_1 { Faker::Address.street_address }
      school_address_line_2 { Faker::Address.secondary_address }
      school_city { Faker::Address.city }
      school_postcode { Faker::Address.postcode }
    end
  end
end
