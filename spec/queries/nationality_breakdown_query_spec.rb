require "rails_helper"

RSpec.describe NationalityBreakdownQuery, type: :model do
  describe "#call" do
    context "when there are a few applicants" do
      before do
        create(:application, :not_submitted, applicant: create(:applicant, nationality: "Nationality 1"))

        create(:application, applicant: create(:applicant, nationality: "Nationality 1"))
        create(:application, applicant: create(:applicant, nationality: "Nationality 3"))
        create(:application, applicant: create(:applicant, nationality: "Nationality 4"))

        create(:application, applicant: create(:applicant, nationality: "Nationality 2"))
        create(:application, applicant: create(:applicant, nationality: "Nationality 2"))
        create(:application, applicant: create(:applicant, nationality: "Nationality 2"))

        create(:application, applicant: create(:applicant, nationality: "Nationality 5"))
        create(:application, applicant: create(:applicant, nationality: "Nationality 5"))
      end

      it "returns the correct route breakdown numbers" do
        result = described_class.new.call

        expect(result).to eq({
          "Nationality 2" => 3,
          "Nationality 5" => 2,
          "Nationality 1" => 1,
          "Nationality 3" => 1,
          "Nationality 4" => 1,
        })
      end

      it "returns the breakdown in the right order" do
        result = described_class.new.call

        expected_keys = ["Nationality 2", "Nationality 5"]

        expect(result.keys.first(2)).to eq(expected_keys)
      end
    end

    context "when there are no applicants" do
      it "returns the empty hash breakdown" do
        result = described_class.new.call

        expect(result).to eq({})
      end
    end
  end
end
