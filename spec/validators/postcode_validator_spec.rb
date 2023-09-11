# frozen_string_literal: true

require "rails_helper"

describe PostcodeValidator do
  subject(:employment) { EmploymentDetailsStep.new(form) }
  let(:form) { build(:form, school_postcode: postcode) }

  context "with a valid UK postcode" do
    let(:postcode) { "SW1A 1AA" }

    it "does not add an error" do
      employment.valid?

      expect(employment.errors[:school_postcode]).to be_blank
    end
  end

  context "with an invalid UK postcode" do
    let(:postcode) { "not really a postcode" }

    it "adds an error" do
      employment.valid?

    expect(employment.errors[:school_postcode]).not_to be_blank
    end
  end
end
