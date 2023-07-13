# frozen_string_literal: true

require "rails_helper"

describe "Gatekeeper" do
  subject(:settings) { AppSettings.current }

  let(:valid_attributes) do
    {
      service_start_date: 1.day.ago,
      service_end_date: 1.year.from_now,
    }
  end

  before { AppSettings.current.update!(valid_attributes) }

  it "returns false when service start date is nil" do
    AppSettings.current.update!(service_start_date: nil)

    expect(Gatekeeper.application_open?).to be(false)
  end

  it "returns false when service end date is nil" do
    AppSettings.current.update!(service_end_date: nil)

    expect(Gatekeeper.application_open?).to be(false)
  end
end
