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
require 'rails_helper'

RSpec.describe Role, type: :model do
  it { is_expected.to have_db_column(:name) }
end
