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
#  urn               :string           not null
#  visa_type         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  applicant_id      :bigint           not null
#
# Foreign Keys
#
#  fk_rails_...  (applicant_id => applicants.id)
#
class Application < ApplicationRecord
  belongs_to :applicant, optional: true
  has_one :application_progress, dependent: :destroy

  before_create :generate_urn

private

  def generate_urn
    route_type = applicant.application_route

    self.urn = Urn.generate(route_type)
  end
end
