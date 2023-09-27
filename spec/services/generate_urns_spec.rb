require "rails_helper"

RSpec.describe GenerateUrns do
  describe ".generate" do
    subject(:generate) { described_class.new(code:).generate }

    before do
      allow(Urn).to receive(:insert_all)
      stub_const "Urn::MAX_SUFFIX", 3
      generate
    end

    let(:code) { "TE" }
    let(:expected_data) do
      [
        { prefix: "IRP", code: code, suffix: 1 },
        { prefix: "IRP", code: code, suffix: 2 },
      ]
    end

    it { expect(Urn).to have_received(:insert_all).with(match_array(expected_data)) }
  end
end
