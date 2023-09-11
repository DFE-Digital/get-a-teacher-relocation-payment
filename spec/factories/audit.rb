FactoryBot.define do
  factory :audit, class: "Audited::Audit" do
    user
    audited_changes { { "status" => ["initial_checks_completed", ""] } }
    action { "update" }
    created_at { Time.zone.now }
  end
end
