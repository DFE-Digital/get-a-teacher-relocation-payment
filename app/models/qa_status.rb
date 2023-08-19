# == Schema Information
#
# Table name: qa_statuses
#
#  id             :bigint           not null, primary key
#  date           :date
#  status         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  application_id :bigint
#
# Foreign Keys
#
#  fk_rails_...  (application_id => applications.id)
#
class QaStatus < ApplicationRecord
end
