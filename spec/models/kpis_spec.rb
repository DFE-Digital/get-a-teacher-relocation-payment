require "rails_helper"

RSpec.describe Kpis do
  subject(:kpis) { described_class.new(unit:, range_start:, range_end:) }

  let(:unit) { "hours" }
  let(:range_start) { "12" }
  let(:range_end) { "0" }

  let(:application) { create(:application) }

  describe "argument error on initialize" do
    context "when unknown unit" do
      let(:unit) { "bad" }

      it { expect { kpis }.to raise_error(ArgumentError) }
    end

    context "when bad range_start and range_end" do
      let(:range_start) { "bad" }
      let(:range_end) { "bad" }

      it { expect { kpis }.to raise_error(ArgumentError) }
    end

    context "when range_start negative" do
      let(:range_start) { "-15" }

      it { expect { kpis }.to raise_error(ArgumentError) }
    end

    context "when range_end negative" do
      let(:range_end) { "-15" }

      it { expect { kpis }.to raise_error(ArgumentError) }
    end

    context "when range_end value greater than range_start" do
      let(:range_start) { "15" }
      let(:range_end) { "24" }

      it { expect { kpis }.to raise_error(ArgumentError) }
    end
  end

  describe "#total_applications" do
    before { create_list(:application, 5) }

    it { expect(kpis.total_applications).to eq(5) }
  end

  describe "#total_rejections" do
    before { create_list(:application_progress, 5, :rejection_completed, application:) }

    it { expect(kpis.total_rejections).to eq(5) }
  end

  describe "#total_paid" do
    before { create_list(:application_progress, 5, :banking_approval_completed, application:) }

    it { expect(kpis.total_paid).to eq(5) }
  end

  describe "funnel_date_range_title" do
    context "when range_end is set to 0" do
      let(:range_end) { 0 }

      it { expect(kpis.funnel_date_range_title).to eq("last 12 hours") }
    end

    context "when range_end is not 0" do
      let(:range_end) { 6 }

      it { expect(kpis.funnel_date_range_title).to eq("between 12 and 6 hours ago") }
    end
  end
end
