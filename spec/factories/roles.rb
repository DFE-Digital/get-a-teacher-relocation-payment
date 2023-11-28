# == Schema Information
#
# Table name: roles
#
#  id            :bigint           not null, primary key
#  name          :string
#  resource_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_id   :bigint
#
FactoryBot.define do
  factory :role do
    name { "Admin" }

    factory :admin_role do
      name { "admin" }
    end

    factory :super_admin_role do
      name { "super_admin" }
    end

    factory :manager_role do
      name { "manager" }
    end
  end
end
