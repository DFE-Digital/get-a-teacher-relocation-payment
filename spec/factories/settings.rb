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
FactoryBot.define do
  factory :settings, class: "AppSettings" do
    service_start_date { 1.day.ago.to_date }
    service_end_date { 1.year.from_now.to_date }
  end
end
