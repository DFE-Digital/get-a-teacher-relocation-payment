require "rails_helper"

RSpec.describe SubjectBreakdownQuery, type: :model do
  describe "#call" do
    context "when there are a few applicants" do
      before do
        create(:application, :not_submitted)
        create(:application, subject: :physics)
        create(:application, subject: :languages)
        create(:application, subject: :general_science)
      end

      it "returns the correct subject breakdown" do
        result = described_class.new.call

        expect(result).to eq({
          "physics" => 1,
          "languages" => 1,
          "general_science" => 1,
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
