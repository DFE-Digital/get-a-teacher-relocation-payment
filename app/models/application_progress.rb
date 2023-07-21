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
#  visa_investigation_required       :boolean          default(FALSE), not null
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  application_id                    :bigint
#
class ApplicationProgress < ApplicationRecord
  belongs_to :application

  def sla_breached?
    SlaChecker.new(self).breached?
  end
end
