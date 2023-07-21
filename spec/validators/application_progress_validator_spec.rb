require "rails_helper"

RSpec.describe ApplicationProgressValidator, type: :model do
  let(:progress) { create(:application_progress, application: build(:application)) }

  shared_examples "validates dates" do |date_param|
    let(:params) { { "#{date_param}(3i)" => "31", "#{date_param}(2i)" => "2", "#{date_param}(1i)" => "2023" } }

    it "adds an error for the invalid date", :aggregate_failures do
      validator = described_class.new(progress, params)

      expect(validator.valid?).to be false
      expect(progress.errors.details[date_param]).to include(error: "is not a valid date")
    end
  end

  shared_examples "allows empty dates" do |date_param|
    let(:params) { { "#{date_param}(3i)" => "", "#{date_param}(2i)" => "", "#{date_param}(1i)" => "" } }

    it "does not add an error for the empty date", :aggregate_failures do
      validator = described_class.new(progress, params)

      expect(validator.valid?).to be true
      expect(progress.errors.details[date_param]).to be_empty
    end
  end

  shared_examples "requires a rejection reason" do
    let(:params) { { "rejection_reason" => "", "rejection_completed_at(3i)" => "1", "rejection_completed_at(2i)" => "1", "rejection_completed_at(1i)" => "2023" } }

    it "adds an error for the missing rejection reason", :aggregate_failures do
      validator = described_class.new(progress, params)

      expect(validator.valid?).to be false
      expect(progress.errors.details[:rejection_reason]).to include(error: :blank)
    end
  end

  ApplicationProgressValidator::DATE_PARAMS.each do |date_param|
    it_behaves_like "validates dates", date_param
    it_behaves_like "allows empty dates", date_param
  end

  it_behaves_like "requires a rejection reason"
end
