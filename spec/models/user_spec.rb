# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :citext
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe User do
  it { is_expected.to have_db_column(:email) }
end
