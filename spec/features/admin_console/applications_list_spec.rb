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

  def given_there_are_few_applications
    create(:teacher_application, subject: :physics)
    create(:teacher_application, subject: :languages)
    create(:salaried_trainee_application, subject: :general_science)
  end

  def when_i_am_in_the_applications_list_page
    visit(applicants_path)
  end

  def then_i_can_see_the_correct_columns
    within ".govuk-table thead" do
      expect(page).to have_content("URN")
      expect(page).to have_content("Name")
      expect(page).to have_content("Email")
      expect(page).to have_content("Passport")
      expect(page).to have_content("Submitted")
      expect(page).to have_content("Initial Checks")
      expect(page).to have_content("HO Checks")
      expect(page).to have_content("School Checks")
      expect(page).to have_content("Banking Approved")
      expect(page).to have_content("Rejected")
    end
  end

  def then_i_can_see_the_pagination
    within "nav.govuk-pagination" do
      expect(page).to have_content("1")
    end
  end
end
