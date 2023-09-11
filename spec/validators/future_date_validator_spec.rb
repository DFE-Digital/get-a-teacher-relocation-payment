require "rails_helper"

describe FutureDateValidator do
  subject(:validator) { described_class.new(form, :date_of_birth) }

  let(:form) { build(:form) }

  before do
    form.date_of_birth = dob
    validator.validate
  end

  context "returns no error when date not in the future" do
    let(:dob) { 1.day.ago }

    it { expect(form.errors[:date_of_birth]).to be_blank }
  end

  context "returns an error when date is in the future" do
    let(:dob) { 1.day.from_now }

    it { expect(form.errors[:date_of_birth]).to be_present }
  end
end
