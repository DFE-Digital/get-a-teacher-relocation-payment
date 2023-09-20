require "rails_helper"

RSpec.describe GenderBreakdownQuery, type: :model do
  describe "#call" do
    context "when there are a few applicants" do
      before do
        create(:application, applicant: create(:applicant, sex: "male"))
        create(:application, applicant: create(:applicant, sex: "female"))
        create(:application, applicant: create(:applicant, sex: "male"))
      end

      it "returns the correct route breakdown" do
        result = described_class.new.call

        expect(result).to eq({
          "male" => 2,
          "female" => 1,
        })
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
