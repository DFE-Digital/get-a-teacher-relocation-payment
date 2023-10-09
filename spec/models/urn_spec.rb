# == Schema Information
#
# Table name: urns
#
#  id         :bigint           not null, primary key
#  code       :string
#  prefix     :string
#  suffix     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Urn do
  describe "next" do
    subject(:next_urn) { described_class.next(route) }

    context "for application route teacher" do
      let(:route) { "teacher" }

      before { create(:urn, code: "TE") }

      it { expect(next_urn).to match(/IRPTE\d{5}/) }
    end

    context "for application route salaried_trainee" do
      let(:route) { "salaried_trainee" }

      before { create(:urn, code: "ST") }

      it { expect(next_urn).to match(/IRPST\d{5}/) }
    end

    context "when bad application route" do
      let(:route) { "badroute" }

      it { expect { next_urn }.to raise_error(ArgumentError) }
    end

    context "when there is no more urn available to assign" do
      let(:route) { "salaried_trainee" }

      before do
        allow(described_class).to receive(:find_by!).and_raise(ActiveRecord::RecordNotFound)
      end

      it { expect { next_urn }.to raise_error(Urn::NoUrnAvailableError) }
    end
  end

  describe ".to_s" do
    subject(:urn) { described_class.new(prefix:, code:, suffix:) }

    let(:prefix) { "AST" }
    let(:code) { "FF" }
    let(:suffix) { 65 }

    it { expect(urn.to_s).to eq("ASTFF00065") }
  end
end
