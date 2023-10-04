# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :citext
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  rolify
  audited
  devise :omniauthable, omniauth_providers: %i[azure_activedirectory_v2]
end
