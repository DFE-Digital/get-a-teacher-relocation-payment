# frozen_string_literal: true

require "rails_helper"

describe "Applications List" do
  include AdminHelpers

  it "shows the correct columns" do
    given_there_are_few_applications
    given_i_am_signed_as_an_admin
    when_i_am_in_the_applications_list_page
    then_i_can_see_the_correct_columns
  end

  it "shows the pagination" do
    given_there_are_few_applications
    given_i_am_signed_as_an_admin
    when_i_am_in_the_applications_list_page
    then_i_can_see_the_pagination
  end

  it "allows searching" do
    given_there_are_few_applications
    given_i_am_signed_as_an_admin
    when_i_am_in_the_applications_list_page
    then_i_can_see_the_search_form
    then_i_can_search_by_urn
  end

  it "highlights applications that breached SLA" do
    given_there_is_an_application_that_breached_sla
    given_i_am_signed_as_an_admin
    when_i_am_in_the_applications_list_page
    then_i_can_see_the_application_is_highlighted
  end

  def given_there_are_few_applications
    # Create 2 specific applications for search tests
    unique_applicant = create(:applicant, given_name: "Unique Given Name", family_name: "Unique Family Name", email_address: "unique@example.com")
    create(:application, applicant: unique_applicant, urn: "Unique Urn 1")

    another_applicant = create(:applicant, given_name: "Another Given Name", family_name: "Another Family Name", email_address: "another@example.com")
    create(:application, applicant: another_applicant, urn: "Unique Urn 2")

    # Create 19 more applications for pagination test
    create_list(:application, 19)
  end

  def given_there_is_an_application_that_breached_sla
    applicant = create(:applicant)
    application = create(:application, applicant:)
    application.application_progress.update(initial_checks_completed_at: 4.days.ago)
  end

  def when_i_am_in_the_applications_list_page
    visit(applicants_path)
  end

  def then_i_can_see_the_correct_columns
    within ".govuk-table thead" do
      expect(page).to have_content("URN")
      expect(page).to have_content("Name")
      expect(page).to have_content("Submitted")
      expect(page).to have_content("Initial Checks")
      expect(page).to have_content("Home Office Checks")
      expect(page).to have_content("School Checks")
      expect(page).to have_content("Bank Details Approved")
      expect(page).to have_content("Rejected")
    end
  end

  def then_i_can_see_the_pagination
    within "nav.govuk-pagination" do
      expect(page).to have_content("1")
    end
  end

  def then_i_can_see_the_search_form
    expect(page).to have_css("form#search")
  end

  def then_i_can_search_by_urn
    fill_in "search", with: "Unique Urn 2"
    click_button "Search"
    expect(page).to have_content("Another Given Name Another Family Name")
    expect(page).to have_content("Unique Urn 2")
  end

  def then_i_can_see_the_application_is_highlighted
    expect(page).to have_css("tr.sla-breached")
  end
end
