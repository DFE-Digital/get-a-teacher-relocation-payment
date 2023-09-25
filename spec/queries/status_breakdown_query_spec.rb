require "rails_helper"

RSpec.describe StatusBreakdownQuery, type: :service do
  subject(:breakdown) { described_class.call }

  describe ".call" do
    let(:expected_breakdown) do
      {
        "initial_checks" => 0,
        "home_office_checks" => 0,
        "school_checks" => 0,
        "bank_approval" => 0,
        "payment_confirmation" => 0,
        "paid" => 0,
        "rejected" => 0,
      }
    end

    it "returns the ordered application status breakdown" do
      expect(breakdown).to include(expected_breakdown)
    end

    context "with data" do
      before do
        create(:application, :with_initial_checks_completed)
      end

      let(:expected_breakdown) do
        {
          "initial_checks" => 0,
          "home_office_checks" => 1,
          "school_checks" => 0,
          "bank_approval" => 0,
          "payment_confirmation" => 0,
          "paid" => 0,
          "rejected" => 0,
        }
      end

      it "returns the ordered application status breakdown" do
        expect(breakdown).to include(expected_breakdown)
      end
    end
  end
end
