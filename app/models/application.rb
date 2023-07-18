# == Schema Information
#
# Table name: applications
#
#  id                :bigint           not null, primary key
#  application_date  :date
#  application_route :string
#  date_of_entry     :date
#  start_date        :date
#  subject           :string
#  urn               :string
#  visa_type         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  applicant_id      :bigint
#
# Foreign Keys
#
#  fk_rails_...  (applicant_id => applicants.id)
#
class Application < ApplicationRecord
  belongs_to :applicant, optional: true
  has_one :application_progress, dependent: :destroy

  scope :submitted, -> { where.not(urn: nil) }

  scope :search, lambda { |term|
                   return if term.blank?

                   term = "%#{term.downcase}%"
                   joins(:applicant).where(
                     "applications.urn ILIKE :term OR
       applicants.email_address ILIKE :term OR
       applicants.passport_number ILIKE :term OR
       CONCAT(applicants.given_name, ' ', applicants.family_name) ILIKE :term OR
       applicants.given_name ILIKE :term OR
       applicants.family_name ILIKE :term",
                     term:,
                   )
                 }

  scope :filter_by_status, lambda { |status|
                             return if status.blank?

                             joins(:application_progress).where(application_progresses: { status: ApplicationProgress.statuses[status] })
                           }

  with_options if: :submitted? do
    validates(:application_date, presence: true)
    validates(:application_route, presence: true)
    validates(:date_of_entry, presence: true)
    validates(:start_date, presence: true)
    validates(:subject, presence: true)
    validates(:visa_type, presence: true)
    validates(:urn, presence: true)
    validates(:applicant, presence: true)
  end

  def assign_urn!
    update!(urn: Urn.generate(application_route))
  end

  def submitted?
    urn.present?
  end
end
