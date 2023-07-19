# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :citext
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
  end
end
