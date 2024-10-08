# frozen_string_literal: true

require "rails_helper"

describe "Open / Close service" do
  include AdminHelpers
  include_context "with common application form steps"
  include_context "with common application form assertions"

  context "when the service is open" do
    before do
      allow(Gatekeeper).to receive(:application_open?).and_return(true)
    end

    it "allows the user access to the landing page" do
      visit root_path

      then_i_can_see_the_landing_page
    end

    it "allows the user access to the admin tool" do
      given_i_am_signed_with_role(:admin)
      visit applicants_path

      expect(page).to have_text("Applications")
    end
  end

  context "when the service is closed" do
    before do
      allow(Gatekeeper).to receive(:application_open?).and_return(false)
    end

    it "does not allow the user access to the landing page" do
      visit root_path

      expect(page.current_url).to eql("https://getintoteaching.education.gov.uk/non-uk-teachers/get-an-international-relocation-payment")
    end
  end
end
