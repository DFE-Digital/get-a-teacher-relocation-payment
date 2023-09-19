require "rails_helper"

RSpec.describe VisaBreakdownQuery, type: :model do
  describe "#call" do
    context "when there are a few applicants" do
      before do
        create(:application, visa_type: "visa_1")
        create_list(:application, 2, visa_type: "visa_2")
        create_list(:application, 4, visa_type: "visa_3")
      end

      it "returns the correct visa breakdown" do
        result = described_class.new.call

        expect(result).to eq({
          "visa_3" => 4,
          "visa_2" => 2,
          "visa_1" => 1,
        })
      end

      it "returns the breakdown in the right order" do
        result = described_class.new.call

        expected_keys = %w[visa_3 visa_2 visa_1]

        expect(result.keys).to eq(expected_keys)
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
