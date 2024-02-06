require "rails_helper"

RSpec.describe TimeToSchoolChecksQuery, type: :model do
  describe "#call" do
    context "with various days taken for school checks" do
      before do
        create(:application_progress, :school_checks_completed,
               application: build(:application),
               home_office_checks_completed_at: 10.days.ago, school_checks_completed_at: 5.days.ago)
        create(:application_progress, :school_checks_completed,
               application: build(:application),
               home_office_checks_completed_at: 20.days.ago, school_checks_completed_at: 10.days.ago)
        create(:application_progress, :school_checks_completed,
               application: build(:application),
               home_office_checks_completed_at: 30.days.ago, school_checks_completed_at: 15.days.ago)
      end

      it "returns min, max and average time in days" do
        result = described_class.new.call

        expect(result[:min]).to eq "5 days"
        expect(result[:max]).to eq "15 days"
        expect(result[:average]).to eq "10 days"
      end
    end

    context "with school checks completed within a day" do
      before do
        create(:application_progress, :school_checks_completed,
               application: build(:application),
               home_office_checks_completed_at: 0.days.ago, school_checks_completed_at: 0.days.ago)
        create(:application_progress, :school_checks_completed,
               application: build(:application),
               home_office_checks_completed_at: 1.day.ago, school_checks_completed_at: 0.days.ago)
      end

      it "returns correct pluralization for 0 days and 1 day" do
        result = described_class.new.call
        expect(result[:min]).to eq "0 days"
        expect(result[:max]).to eq "1 day"
      end
    end
  end
end
