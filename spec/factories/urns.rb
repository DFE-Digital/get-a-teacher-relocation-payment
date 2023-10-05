FactoryBot.define do
  factory :urn do
    prefix { "IRP" }
    code { %w[TE ST].sample }
    suffix { Array.new(10) { _1 }.sample }
  end
end
