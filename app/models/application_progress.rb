# frozen_string_literal: true

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
class ApplicationProgress < ApplicationRecord
  audited on: [:update]
  belongs_to :application

  validates :rejection_reason, presence: true, if: :rejection_completed_at?
  enum status: {
    initial_checks: 0,
    home_office_checks: 1,
    school_checks: 2,
    bank_approval: 3,
    payment_confirmation: 4,
    paid: 5,
    rejected: 6,
  }

  enum rejection_reason: {
    suspected_fraud: 0,
    duplicate_submission: 1,
    ineligible_school: 2,
    home_office_checks_failed: 3,
    school_checks_failed: 4,
    standing_data_checks_failed: 5,
    no_longer_in_post: 6,
    request_to_re_submit: 7,
    unable_complete_school_checks: 8,
  }

  before_save -> { self.status = StatusQuery.new(self).current_status }

  def sla_breached?
    SlaChecker.new(self).breached?
  end
end
