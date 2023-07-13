# frozen_string_literal: true

require "rails_helper"

describe "Settings" do
  include AdminHelpers

  it "shows the app_settings page" do
    given_i_am_signed_as_an_admin
    when_i_visit_the_settings_page
    then_i_should_see_the_settings_page
  end

  it "updates the app_settings page" do
    given_i_am_signed_as_an_admin
    when_i_visit_the_settings_page
    and_i_update_the_settings_page
    then_i_should_see_the_settings_updated
  end

private

  def when_i_visit_the_settings_page
    visit edit_settings_path
  end

  def and_i_update_the_settings_page
    within(".service-start-date") do
      fill_in("Day", with: 1)
      fill_in("Month", with: 1)
      fill_in("Year", with: 2023)
    end

    within(".service-end-date") do
      fill_in("Day", with: 31)
      fill_in("Month", with: 1)
      fill_in("Year", with: 2023)
    end

    click_on "Save"
  end

  def then_i_should_see_the_settings_updated
    within(".service-start-date") do
      expect(find_field("Day").value).to eq("1")
      expect(find_field("Month").value).to eq("1")
      expect(find_field("Year").value).to eq("2023")
    end

    within(".service-end-date") do
      expect(find_field("Day").value).to eq("31")
      expect(find_field("Month").value).to eq("1")
      expect(find_field("Year").value).to eq("2023")
    end
  end

  def then_i_should_see_the_settings_page
    expect(page).to have_content("Application Settings")
  end
end
