# == Schema Information
#
# Table name: applicants
#
#  id              :bigint           not null, primary key
#  date_of_birth   :date
#  email_address   :text
#  family_name     :text
#  given_name      :text
#  nationality     :text
#  passport_number :text
#  phone_number    :text
#  sex             :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  school_id       :bigint
#
# Foreign Keys
#
#  fk_rails_...  (school_id => schools.id)
#
Faker::Config.locale = "en-GB"

FactoryBot.define do
  factory :applicant do
    date_of_birth { rand(18..90).years.ago.to_date }
    email_address { Faker::Internet.email }
    family_name { Faker::Name.last_name }
    given_name { Faker::Name.first_name }
    nationality { Faker::Nation.nationality }
    passport_number { Faker::Number.number(digits: 9) }
    phone_number { Faker::PhoneNumber.cell_phone_in_e164 }
    sex { %w[female male].sample }

    school factory: %i[school], strategy: :build

    after(:build) do |applicant|
      build(:address, addressable: applicant)
    end
  end
end
