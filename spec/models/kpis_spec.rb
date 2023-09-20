require "rails_helper"

RSpec.describe Kpis do
  describe "#total_applications" do
    it "returns the total number of applications" do
      create(:application, :not_submitted)
      create_list(:application, 5)

      kpis = described_class.new

      expect(kpis.total_applications).to eq(5)
    end
  end

  describe "#total_rejections" do
    it "returns the total number of applications rejected" do
      application = create(:application)
      create_list(:application_progress, 5, :rejection_completed, application:)

      stats = described_class.new

      expect(stats.total_rejections).to eq(5)
    end
  end

  describe "#total_paid" do
    it "returns the total number of applications paid" do
      application = create(:application)
      create_list(:application_progress, 5, :banking_approval_completed, application:)

      stats = described_class.new

      expect(stats.total_paid).to eq(5)
    end
  end
end
