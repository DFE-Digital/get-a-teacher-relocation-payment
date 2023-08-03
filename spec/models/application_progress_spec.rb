# == Schema Information
#
# Table name: application_progresses
#
#  id                                :bigint           not null, primary key
#  banking_approval_completed_at     :date
#  home_office_checks_completed_at   :date
#  initial_checks_completed_at       :date
#  payment_confirmation_completed_at :date
#  rejection_completed_at            :date
#  rejection_reason                  :text
#  school_checks_completed_at        :date
#  school_investigation_required     :boolean          default(FALSE), not null
#  status                            :integer          default("initial_checks")
#  visa_investigation_required       :boolean          default(FALSE), not null
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  application_id                    :bigint
#
require "rails_helper"

RSpec.describe ApplicationProgress do
  let(:application_progress) { create(:application_progress, application: build(:application)) }

  describe "before save callback" do
    context "when rejection_completed_at is present" do
      it "updates status to rejected" do
        application_progress.rejection_completed_at = Time.current
        application_progress.save
        expect(application_progress.status).to eq("rejected")
      end
    end

    context "when payment_confirmation_completed_at is present" do
      it "updates status to paid" do
        application_progress.payment_confirmation_completed_at = Time.current
        application_progress.save
        expect(application_progress.status).to eq("paid")
      end
    end

    context "when banking_approval_completed_at is present" do
      it "updates status to payment_confirmation" do
        application_progress.banking_approval_completed_at = Time.current
        application_progress.save
        expect(application_progress.status).to eq("payment_confirmation")
      end
    end

    context "when school_checks_completed_at is present" do
      it "updates status to bank_approval" do
        application_progress.school_checks_completed_at = Time.current
        application_progress.save
        expect(application_progress.status).to eq("bank_approval")
      end
    end

    context "when home_office_checks_completed_at is present" do
      it "updates status to school_checks" do
        application_progress.home_office_checks_completed_at = Time.current
        application_progress.save
        expect(application_progress.status).to eq("school_checks")
      end
    end

    context "when initial_checks_completed_at is present" do
      it "updates status to home_office_checks" do
        application_progress.initial_checks_completed_at = Time.current
        application_progress.save
        expect(application_progress.status).to eq("home_office_checks")
      end
    end

    context "when only created_at is present" do
      it "updates status to initial_checks" do
        expect(application_progress.status).to eq("initial_checks")
      end
    end
  end
end
