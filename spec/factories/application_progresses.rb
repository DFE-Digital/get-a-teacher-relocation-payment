# == Schema Information
#
# Table name: application_progresses
#
#  id                                :bigint           not null, primary key
#  banking_approval_completed_at     :date
#  comments                          :text
#  home_office_checks_completed_at   :date
#  initial_checks_completed_at       :date
#  payment_confirmation_completed_at :date
#  rejection_completed_at            :date
#  rejection_reason                  :integer
#  school_checks_completed_at        :date
#  school_investigation_required     :boolean          default(FALSE), not null
#  status                            :integer          default("initial_checks")
#  visa_investigation_required       :boolean          default(FALSE), not null
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  application_id                    :bigint
#
FactoryBot.define do
  factory :application_progress do
    # association :application, factory: :application, strategy: :build

    transient do
      sla_created_at { rand(1..2).days }
      sla_initial_checks_completed_at { rand(1..3).days }
      sla_home_office_checks_completed_at { rand(1..5).days }
      sla_school_checks_completed_at { rand(1..15).days }
    end

    trait :initial_checks_completed do
      created_at { rand(41..45).days.ago.to_date }
      initial_checks_completed_at { created_at + sla_created_at }
    end

    trait :home_office_pending do
      initial_checks_completed
      home_office_checks_completed_at { nil }
    end

    trait :rejection_completed do
      created_at { rand(41..45).days.ago.to_date }
      rejection_completed_at { created_at + rand(3..5).days }
      rejection_reason { :suspected_fraud }
    end

    trait :visa_investigation_required do
      initial_checks_completed

      visa_investigation_required { true }
    end

    trait :home_office_checks_completed do
      visa_investigation_required

      home_office_checks_completed_at { initial_checks_completed_at + sla_initial_checks_completed_at }
    end

    trait :school_investigation_required do
      home_office_checks_completed

      school_investigation_required { true }
    end

    trait :school_checks_completed do
      school_investigation_required

      school_checks_completed_at { home_office_checks_completed_at + sla_home_office_checks_completed_at }
    end

    trait :banking_approval_completed do
      school_checks_completed

      banking_approval_completed_at { school_checks_completed_at + sla_school_checks_completed_at }
    end

    trait :payment_confirmation_completed do
      banking_approval_completed

      payment_confirmation_completed_at { banking_approval_completed_at + rand(1..2).days }
    end
  end
end
