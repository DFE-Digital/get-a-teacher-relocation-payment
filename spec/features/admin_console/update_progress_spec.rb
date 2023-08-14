require "rails_helper"

describe "Application Progress" do
  include AdminHelpers
  let(:application) { create(:application) }

  it "validates the date fields" do
    given_i_am_signed_as_an_admin
    given_i_am_on_the_edit_application_page
    when_i_submit_an_invalid_date
    then_i_see_an_error_message
    given_i_am_on_the_edit_application_page
    when_i_submit_a_valid_date
    then_the_submission_is_successful
  end

  it "validates the rejection reason and details fields" do
    given_i_am_signed_as_an_admin

    given_i_am_on_the_edit_application_page
    when_i_submit_a_rejection_without_reason
    then_i_see_a_missing_reason_error_message

    given_i_am_on_the_edit_application_page
    when_i_submit_a_rejection_with_reason
    then_the_submission_is_successful

    given_i_am_on_the_edit_application_page
    when_i_submit_a_rejection_with_reason_and_details
    then_the_submission_is_successful
  end

private

  def given_i_am_on_the_edit_application_page
    visit edit_applicant_path(application.applicant)
  end

  def when_i_submit_an_invalid_date
    fill_in "application_progress_home_office_checks_completed_at_3i", with: "31"
    fill_in "application_progress_home_office_checks_completed_at_2i", with: "02"
    fill_in "application_progress_home_office_checks_completed_at_1i", with: "2023"
    click_button "Update"
  end

  def then_i_see_an_error_message
    expect(page).to have_content("is not a valid date")
  end

  def when_i_submit_a_valid_date
    fill_in "application_progress_home_office_checks_completed_at_3i", with: "28"
    fill_in "application_progress_home_office_checks_completed_at_2i", with: "02"
    fill_in "application_progress_home_office_checks_completed_at_1i", with: "2023"
    click_button "Update"
  end

  def then_the_submission_is_successful
    expect(page).to have_current_path(applicant_path(application.applicant), ignore_query: true)
    expect(page).not_to have_content("is not a valid date")
    expect(page).not_to have_content("can't be blank")
  end

  def when_i_submit_a_rejection_without_reason
    fill_in "application_progress_rejection_completed_at_3i", with: "28"
    fill_in "application_progress_rejection_completed_at_2i", with: "02"
    fill_in "application_progress_rejection_completed_at_1i", with: "2023"
    click_button "Update"
  end

  def then_i_see_a_missing_reason_error_message
    expect(page).to have_content("can't be blank")
  end

  def when_i_submit_a_rejection_with_reason
    fill_in "application_progress_rejection_completed_at_3i", with: "28"
    fill_in "application_progress_rejection_completed_at_2i", with: "02"
    fill_in "application_progress_rejection_completed_at_1i", with: "2023"
    fill_in "application_progress[rejection_reason]", with: "Some reason"
    click_button "Update"
  end

  def when_i_submit_a_rejection_without_reason
    fill_in_rejection_date
    click_button "Update"
  end

  def when_i_submit_a_rejection_with_reason
    fill_in_rejection_date
    select "Suspected fraud", from: "application_progress[rejection_reason]"
    click_button "Update"
  end

  def when_i_submit_a_rejection_with_reason_and_details
    fill_in_rejection_date
    select "Suspected fraud", from: "application_progress[rejection_reason]"
    fill_in "application_progress[rejection_details]", with: "suspected_fraud"
    click_button "Update"
  end

  def fill_in_rejection_date
    fill_in "application_progress_rejection_completed_at_3i", with: "28"
    fill_in "application_progress_rejection_completed_at_2i", with: "02"
    fill_in "application_progress_rejection_completed_at_1i", with: "2023"
  end
end
