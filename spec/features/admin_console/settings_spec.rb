# frozen_string_literal: true

require "rails_helper"

describe "Settings" do
  include AdminHelpers

  it "shows the settings page" do
    given_i_am_signed_as_an_admin
    when_i_visit_the_settings_page
    then_i_should_see_the_settings_page
  end

private

  def when_i_visit_the_settings_page
    visit edit_settings_path
  end

  def then_i_should_see_the_settings_page
    expect(page).to have_content("Application Settings")
  end
end
