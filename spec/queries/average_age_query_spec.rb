require "rails_helper"

RSpec.describe AverageAgeQuery, type: :model do
  describe "#call" do
    context "when there are a few applicants" do
      before do
        create(:application, :not_submitted, applicant: create(:applicant, date_of_birth: 25.years.ago))

        create(:application, applicant: create(:applicant, date_of_birth: 35.years.ago))
        create(:application, applicant: create(:applicant, date_of_birth: 45.years.ago))
        create(:application, applicant: create(:applicant, date_of_birth: 52.years.ago))
      end

      it "returns the correct average age" do
        result = described_class.new.call

        expect(result).to eq(43)
      end
    end

    context "when there are no applicants" do
      it "returns zero" do
        result = described_class.new.call

        expect(result).to eq(0)
      end
    end
  end
end
