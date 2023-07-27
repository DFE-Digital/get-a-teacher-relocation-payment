# == Schema Information
#
# Table name: application_progresses
#
#  id                                :bigint           not null, primary key
#  banking_approval_completed_at     :date
#  home_office_checks_completed_at   :date
#  initial_checks_completed_at       :date
#  payment_confirmation_completed_at :date
#  rejection_completed_at            :date
#  rejection_reason                  :text
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

    trait :initial_checks_completed do
      created_at { rand(41..45).days.ago.to_date }
      initial_checks_completed_at { rand(31..40).days.ago.to_date }
    end

    trait :home_office_pending do
      initial_checks_completed
      home_office_checks_completed_at { nil }
    end

    trait :rejection_completed do
      rejection_completed_at { rand(1..2).days.ago.to_date }
    end

    trait :visa_investigation_required do
      initial_checks_completed

      visa_investigation_required { true }
    end

    trait :home_office_checks_completed do
      visa_investigation_required

      home_office_checks_completed_at { rand(21..30).days.ago.to_date }
    end

    trait :school_investigation_required do
      home_office_checks_completed

      school_investigation_required { true }
    end

    trait :school_checks_completed do
      school_investigation_required

      school_checks_completed_at { rand(11..20).days.ago.to_date }
    end

    trait :banking_approval_completed do
      school_checks_completed

      banking_approval_completed_at { rand(3..11).days.ago.to_date }
    end

    trait :payment_confirmation_completed do
      banking_approval_completed

      payment_confirmation_completed_at { rand(1..2).days.ago.to_date }
    end
  end
end
