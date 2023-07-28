require "rails_helper"

RSpec.describe SlaChecker, type: :service do
  subject(:sla_checker) { described_class.new(application_progress) }

  let(:application_progress) { create(:application_progress, application: build(:application)) }

  describe "#breached?" do
    context "when all steps are completed within SLA" do
      before do
        SlaChecker::SLA_TIMES.each_key do |step|
          application_progress.update(step => (SlaChecker::SLA_TIMES[step] - 1).days.ago)
        end
      end

      it "returns false" do
        expect(sla_checker).not_to be_breached
      end
    end

    context "when the latest step is outside SLA" do
      before do
        SlaChecker::SLA_TIMES.keys.each_with_index do |step, index|
          days_ago = index < SlaChecker::SLA_TIMES.keys.size - 1 ? 1 : (SlaChecker::SLA_TIMES[step] + 1)
          application_progress.update(step => days_ago.days.ago)
        end
      end

      it "returns true" do
        expect(sla_checker).to be_breached
      end
    end

    context "when the application is already processed" do
      before do
        application_progress.update(banking_approval_completed_at: Time.zone.now)
      end

      it "returns false" do
        expect(sla_checker).not_to be_breached
      end
    end
  end
end
