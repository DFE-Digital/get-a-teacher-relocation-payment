FactoryBot.define do
  factory :urn do
    prefix { "IRP" }
    code { %w[TE ST].sample }
    sequence(:suffix) { _1 }
  end
end
