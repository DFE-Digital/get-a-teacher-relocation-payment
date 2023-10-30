require "rails_helper"

RSpec.describe Application::Urn do
  describe "constants" do
    it { expect(described_class::LENGTH).to eq(99_999) }
    it { expect(described_class::PREFIX).to eq("IRP") }
    it { expect(described_class::URNS.keys).to contain_exactly("teacher", "salaried_trainee") }
    it { expect(described_class::URNS.dig("teacher", 1)).to include("IRPTE") }
    it { expect(described_class::URNS.fetch("teacher").size).to eq(99_998) }
    it { expect(described_class::URNS.dig("salaried_trainee", 1)).to include("IRPST") }
    it { expect(described_class::URNS.fetch("salaried_trainee").size).to eq(99_998) }
  end

  describe "urn" do
    subject(:service) { described_class.new(application) }

    context "teacher" do
      let(:application) { create(:teacher_application) }

      it { expect(service.urn).to include("IRPTE") }
    end

    context "salaried_trainee" do
      let(:application) { create(:salaried_trainee_application) }

      it { expect(service.urn).to include("IRPST") }
    end

    context "missing application" do
      let(:application) { build(:salaried_trainee_application) }

      it { expect { service.urn }.to raise_error(ArgumentError, "application not found") }
    end
  end
end
