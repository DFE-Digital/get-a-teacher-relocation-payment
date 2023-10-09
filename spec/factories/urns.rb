# == Schema Information
#
# Table name: urns
#
#  id         :bigint           not null, primary key
#  code       :string
#  prefix     :string
#  suffix     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :urn do
    prefix { "IRP" }
    code { %w[TE ST].sample }
    suffix { Array.new(10) { _1 }.sample }
  end
end
