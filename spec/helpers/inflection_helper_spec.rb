# frozen_string_literal: true

require "rails_helper"

RSpec.describe InflectionHelper do
  it "returns singular when count is 1" do
    expect(pluralize_word(1, "day")).to eq "1 day"
  end

  it "returns plural when count is not 1" do
    expect(pluralize_word(0, "day")).to eq "0 days"
    expect(pluralize_word(2, "day")).to eq "2 days"
    expect(pluralize_word(10, "day")).to eq "10 days"
  end
end
