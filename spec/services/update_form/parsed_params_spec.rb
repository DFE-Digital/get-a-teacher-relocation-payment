require "rails_helper"

RSpec.describe UpdateForm::ParsedParams do
  subject(:parsed_params) { described_class.new(params).execute }

  let(:params) do
    {
      "date_of_birth(3i)" => day,
      "date_of_birth(2i) " => month,
      "date_of_birth(1i)" => year,
      "given_name" => "marcel",
    }
  end
  let(:year) { "2023" }
  let(:month) { "9" }
  let(:day) { "1" }

  context "when date valid" do
    let(:expected) do
      {
        "date_of_birth" => Date.new(2023, 9, 1),
        "given_name" => "marcel",
      }
    end

    it { expect(parsed_params).to eq(expected) }
  end

  context "when date year missing" do
    let(:year) { nil }
    let(:expected) do
      {
        "date_of_birth" => nil,
        "given_name" => "marcel",
      }
    end

    it { expect(parsed_params).to eq(expected) }
  end

  context "when date month missing" do
    let(:month) { nil }
    let(:expected) do
      {
        "date_of_birth" => nil,
        "given_name" => "marcel",
      }
    end

    it { expect(parsed_params).to eq(expected) }
  end

  context "when date month out of range" do
    let(:month) { "13" }
    let(:expected) do
      {
        "date_of_birth" => nil,
        "given_name" => "marcel",
      }
    end

    it { expect(parsed_params).to eq(expected) }
  end

  context "when date day missing" do
    let(:day) { nil }
    let(:expected) do
      {
        "date_of_birth" => nil,
        "given_name" => "marcel",
      }
    end

    it { expect(parsed_params).to eq(expected) }
  end

  context "when date day out of range" do
    let(:day) { "32" }
    let(:expected) do
      {
        "date_of_birth" => nil,
        "given_name" => "marcel",
      }
    end

    it { expect(parsed_params).to eq(expected) }
  end
end
