# frozen_string_literal: true

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
class ApplicationProgress < ApplicationRecord
  belongs_to :application

  enum status: {
    initial_checks: 0,
    home_office_checks: 1,
    school_checks: 2,
    bank_approval: 3,
    payment_confirmation: 4,
    paid: 5,
    rejected: 6,
  }

  before_save -> { self.status = StatusQuery.new(self).current_status }
end
