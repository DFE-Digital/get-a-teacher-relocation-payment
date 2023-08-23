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
FactoryBot.define do
  factory :form do
    application_route { %w[salaried_trainee teacher].sample }

    factory :teacher_form do
      application_route { "teacher" }
    end

    factory :trainee_form do
      application_route { "salaried_trainee" }
    end
  end
end
