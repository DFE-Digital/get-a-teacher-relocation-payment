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

  it "returns true when current date is between start and end of the service" do
    expect(Gatekeeper.application_open?).to be(true)
  end

  it "returns false when current date is before start of the service" do
    AppSettings.current.update!(service_start_date: 1.day.from_now)

    expect(Gatekeeper.application_open?).to be(false)
  end

  it "returns false when current date is after end of the service" do
    AppSettings.current.update!(service_end_date: 1.day.ago)

    expect(Gatekeeper.application_open?).to be(false)
  end

  it "returns true when current date is equal to start of the service" do
    AppSettings.current.update!(service_start_date: Time.zone.now.to_date)

    expect(Gatekeeper.application_open?).to be(true)
  end

  it "returns true when current date is equal to end of the service" do
    AppSettings.current.update!(service_end_date: Time.zone.now.to_date)

    expect(Gatekeeper.application_open?).to be(true)
  end
end
