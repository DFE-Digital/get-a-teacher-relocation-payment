require "rails_helper"

RSpec.describe StatusQuery, type: :service do
  subject(:status_query) { described_class.new(progress) }

  let(:progress) { build(:application_progress) }

  describe "#current_status" do
    context "when rejection is completed" do
      before { progress.rejection_completed_at = Time.current }

      it "returns :rejected" do
        expect(status_query.current_status).to eq(:rejected)
      end
    end

    context "when payment confirmation is completed" do
      before { progress.payment_confirmation_completed_at = Time.current }

      it "returns :paid" do
        expect(status_query.current_status).to eq(:paid)
      end
    end

    context "when banking approval is completed" do
      before { progress.banking_approval_completed_at = Time.current }

      it "returns :payment_confirmation" do
        expect(status_query.current_status).to eq(:payment_confirmation)
      end
    end

    context "when school checks are completed" do
      before { progress.school_checks_completed_at = Time.current }

      it "returns :bank_approval" do
        expect(status_query.current_status).to eq(:bank_approval)
      end
    end

    context "when home office checks are completed" do
      before { progress.home_office_checks_completed_at = Time.current }

      it "returns :school_checks" do
        expect(status_query.current_status).to eq(:school_checks)
      end
    end

    context "when initial checks are completed" do
      before { progress.initial_checks_completed_at = Time.current }

      it "returns :home_office_checks" do
        expect(status_query.current_status).to eq(:home_office_checks)
      end
    end

    context "when none of the checks are completed" do
      it "returns :initial_checks" do
        expect(status_query.current_status).to eq(:initial_checks)
      end
    end
  end
end
