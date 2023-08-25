# == Schema Information
#
# Table name: applications
#
#  id                              :bigint           not null, primary key
#  application_date                :date
#  application_route               :string
#  date_of_entry                   :date
#  home_office_csv_downloaded_at   :datetime
#  payroll_csv_downloaded_at       :datetime
#  standing_data_csv_downloaded_at :datetime
#  start_date                      :date
#  subject                         :string
#  urn                             :string
#  visa_type                       :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  applicant_id                    :bigint
#
# Foreign Keys
#
#  fk_rails_...  (applicant_id => applicants.id)
#
class Application < ApplicationRecord
  belongs_to :applicant, optional: true
  has_one :application_progress, dependent: :destroy
  has_many :duplicates, inverse_of: :application, primary_key: :id, class_name: "DuplicateApplication"
  has_many :qa_statuses, dependent: :destroy

  delegate :sla_breached?, to: :application_progress
  delegate :status, to: :application_progress, allow_nil: false

  default_scope { submitted }
  scope :submitted, -> { where.not(urn: nil) }
  scope :in_progress, -> { unscoped.where(urn: nil) }

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

  def qa?
    qa_statuses.exists?(status: application_progress.status)
  end

  def mark_as_qa!
    qa_statuses.upsert({ status: application_progress.status, date: Time.current },
                       unique_by: %i[application_id status])
  end

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
