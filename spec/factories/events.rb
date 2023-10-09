# == Schema Information
#
# Table name: events
#
#  id           :bigint           not null, primary key
#  action       :string
#  data         :jsonb
#  entity_class :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  entity_id    :integer
#
FactoryBot.define do
  factory :event do
    action { Event::ACTIONS.sample }
    entity_class { "Form" }
    entity_id { Faker::Number.number(digits: 3) }
    data do
      {
        "id" => [nil, entity_id],
        "application_route" => [nil, "teacher"],
        "updated_at" => ["2023-09-29T14:40:22.857+01:00", "2023-09-29T14:40:43.388+01:00"],
      }
    end

    factory :form_submitted_event do
      action { "deleted" }
      data { {} }
    end

    factory :form_updated do
      action { "updated" }

      factory :form_school_details_event do
        data do
          {
            "state_funded_secondary_school" => [nil, true],
            "updated_at" => [Time.zone.now, Time.zone.now],
          }
        end
      end

      factory :ineligible_form_school_details_event do
        data do
          {
            "state_funded_secondary_school" => [nil, false],
            "updated_at" => [Time.zone.now, Time.zone.now],
          }
        end
      end

      factory :form_application_route_event do
        data do
          {
            "id" => [nil, entity_id],
            "application_route" => [nil, "teacher"],
            "updated_at" => [nil, Time.zone.now],
            "created_at" => [nil, Time.zone.now],
          }
        end
      end

      factory :ineligible_form_application_route_event do
        data do
          {
            "id" => [nil, entity_id],
            "application_route" => [nil, "other"],
            "updated_at" => [nil, Time.zone.now],
            "created_at" => [nil, Time.zone.now],
          }
        end
      end

      factory :form_start_date_event do
        data do
          {
            "start_date" => [nil, Time.zone.today],
            "updated_at" => [Time.zone.now, Time.zone.now],
          }
        end
      end

      factory :ineligible_form_start_date_event do
        data do
          {
            "start_date" => [nil, 1.year.ago.to_date],
            "updated_at" => [Time.zone.now, Time.zone.now],
          }
        end
      end

      factory :form_start_date_four_months_ago_event do
        data do
          {
            "start_date" => [nil, 4.months.ago.to_date],
            "updated_at" => [Time.zone.now, Time.zone.now],
          }
        end
      end

      factory :form_date_of_entry_event do
        data do
          {
            "date_of_entry" => [nil, Time.zone.today],
            "updated_at" => [Time.zone.now, Time.zone.now],
          }
        end
      end

      factory :ineligible_form_date_of_entry_event do
        data do
          {
            "date_of_entry" => [nil, 1.year.ago.to_date],
            "updated_at" => [Time.zone.now, Time.zone.now],
          }
        end
      end

      factory :form_employment_details_event do
        data do
          {
            "school_city" => [nil, "sth"],
            "school_name" => [nil, "sths"],
            "school_postcode" => [nil, "EE3 3AA"],
            "school_address_line_1" => [nil, "stnh"],
            "school_address_line_2" => [nil, ""],
            "school_headteacher_name" => [nil, "[FILTERED]"],
            "updated_at" => [Time.zone.now, Time.zone.now],
          }
        end
      end

      factory :form_personal_details_event do
        data do
          {
            "sex" => [nil, "[FILTERED]"],
            "city" => [nil, "[FILTERED]"],
            "postcode" => [nil, "[FILTERED]"],
            "given_name" => [nil, "[FILTERED]"],
            "family_name" => [nil, "[FILTERED]"],
            "middle_name" => [nil, "[FILTERED]"],
            "nationality" => [nil, "[FILTERED]"],
            "phone_number" => [nil, "[FILTERED]"],
            "student_loan" => [nil, true],
            "date_of_birth" => [nil, "[FILTERED]"],
            "email_address" => [nil, "[FILTERED]"],
            "address_line_1" => [nil, "[FILTERED]"],
            "address_line_2" => [nil, "[FILTERED]"],
            "passport_number" => [nil, "[FILTERED]"],
            "updated_at" => [Time.zone.now, Time.zone.now],
          }
        end
      end
    end
  end
end
