require "rails_helper"

RSpec.describe ApplicationsIndexQuery, type: :model do
  subject(:sql) { described_class.new.to_sql }

  describe "#to_sql" do
    it { expect(sql).to include("SELECT") }
    it { expect(sql).to include('"applications"."id"') }
    it { expect(sql).to include("ROW_NUMBER() OVER (ORDER BY created_at ASC) AS application_index") }
    it { expect(sql).to include('FROM "applications"') }
  end
end
