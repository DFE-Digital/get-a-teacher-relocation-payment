require "rails_helper"

RSpec.describe FindApplicationIndexQuery, type: :model do
  subject(:sql) { described_class.new(application_id: application.id).to_sql }

  let(:application) { create(:application) }
  let(:subquery) { ApplicationsIndexQuery.new.to_sql }

  describe "#to_sql" do
    it { expect(sql).to include("SELECT *") }
    it { expect(sql).to include("FROM (#{subquery}) list") }
    it { expect(sql).to include("WHERE list.id = #{application.id}") }
  end
end
