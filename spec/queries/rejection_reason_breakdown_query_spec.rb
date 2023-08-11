require "rails_helper"

RSpec.describe RejectionReasonBreakdownQuery, type: :model do
  describe "#call" do
    context "when there are a few application progresses with rejection reasons" do
      before do
        applicant = create(:applicant)
        create(:application_progress, application: create(:application, applicant:), rejection_reason: "suspected_fraud")
        create(:application_progress, application: create(:application, applicant:), rejection_reason: "suspected_fraud")
        create(:application_progress, application: create(:application, applicant:), rejection_reason: "ineligible_school")
        create(:application_progress, application: create(:application, :not_submitted, applicant:), rejection_reason: "duplicate_submission") # This one should not be included in the count because the associated application is not submitted
      end

      it "returns the correct rejection reason breakdown" do
        result = described_class.new.call

        expect(result).to eq({
          "suspected_fraud" => 2,
          "ineligible_school" => 1,
        })
      end
    end

    context "when there are no application progresses" do
      it "returns an empty hash breakdown" do
        result = described_class.new.call

        expect(result).to eq({})
      end
    end
  end
end
