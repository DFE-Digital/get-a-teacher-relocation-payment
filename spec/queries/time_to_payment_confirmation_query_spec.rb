require "rails_helper"

RSpec.describe TimeToPaymentConfirmationQuery, type: :model do
  describe "#call" do
    before do
      create(:application_progress, :payment_confirmation_completed, application: build(:application),
                                                                     banking_approval_completed_at: 10.days.ago, payment_confirmation_completed_at: 5.days.ago)
      create(:application_progress, :payment_confirmation_completed, application: build(:application),
                                                                     banking_approval_completed_at: 20.days.ago, payment_confirmation_completed_at: 10.days.ago)
      create(:application_progress, :payment_confirmation_completed, application: build(:application),
                                                                     banking_approval_completed_at: 30.days.ago, payment_confirmation_completed_at: 15.days.ago)
    end

    it "returns min, max and average time in days" do
      result = described_class.new.call

      expect(result[:min]).to eq "5 days"
      expect(result[:max]).to eq "15 days"
      expect(result[:average]).to eq "10 days"
    end

    context "with different day counts" do
      before do
        ApplicationProgress.delete_all
        create(:application_progress, :payment_confirmation_completed,
               application: build(:application),
               banking_approval_completed_at: 0.days.ago, payment_confirmation_completed_at: 0.days.ago)
        create(:application_progress, :payment_confirmation_completed,
               application: build(:application),
               banking_approval_completed_at: 1.day.ago, payment_confirmation_completed_at: 0.days.ago)
      end

      it "returns correct pluralization for 0 days and 1 day" do
        result = described_class.new.call
        expect(result[:min]).to eq "0 days"
        expect(result[:max]).to eq "1 day"
      end
    end
  end
end
