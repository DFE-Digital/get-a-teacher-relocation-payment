# == Schema Information
#
# Table name: settings
#
#  id                 :bigint           not null, primary key
#  service_end_date   :date
#  service_start_date :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require "rails_helper"

RSpec.describe Setting do
  pending "add some examples to (or delete) #{__FILE__}"
end
