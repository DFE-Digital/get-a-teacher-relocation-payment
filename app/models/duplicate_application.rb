# == Schema Information
#
# Table name: duplicate_applications
#
#  id                :bigint
#  application_date  :date
#  application_route :string
#  date_of_entry     :date
#  duplicate_email   :text
#  start_date        :date
#  subject           :string
#  urn               :string
#  visa_type         :string
#  created_at        :datetime
#  updated_at        :datetime
#  applicant_id      :bigint
#
class DuplicateApplication < ApplicationRecord
  belongs_to :application, foreign_key: :urn, primary_key: :urn, inverse_of: :duplicates
  belongs_to :applicant, optional: true

  delegate :application_progress, to: :application
  delegate :status, to: :application_progress
  delegate :phone_number, :passport_number, :email_address, to: :applicant

  scope :search, lambda { |term|
                   return if term.blank?

                   term = "%#{term.downcase}%"
                   joins(:applicant).where(
                     "applicants.email_address ILIKE :term OR
                     applicants.passport_number ILIKE :term OR
                     applicants.phone_number ILIKE :term",
                     term:,
                   )
                 }

  def readonly?
    true
  end
end
