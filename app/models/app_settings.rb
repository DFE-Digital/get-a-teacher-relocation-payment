# == Schema Information
#
# Table name: app_settings
#
#  id                 :bigint           not null, primary key
#  service_end_date   :date
#  service_start_date :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class AppSettings < ApplicationRecord
  audited
  def self.current
    AppSettings.first_or_create!
  end

  private_class_method :new
end
