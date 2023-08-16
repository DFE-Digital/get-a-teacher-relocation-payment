# spec/features/duplicates_search_spec.rb
require "rails_helper"

RSpec.describe "Duplicates Search" do
  include AdminHelpers

  let!(:applicant_one) { create(:applicant, email_address: "test@example.com", passport_number: "123456", phone_number: "111222333") }
  let!(:applicant_two) { create(:applicant, email_address: "test@example.com", passport_number: "654321", phone_number: "444555666") }

  before do
    create(:application, applicant: applicant_one)
    create(:application, applicant: applicant_two)
  end

  it "Admin can search for duplicates by email" do
    given_i_am_signed_as_an_admin
    when_i_search_for_a_duplicate_by("email")
    then_i_see_matching_duplicates
  end

  it "Admin can search for duplicates by phone number" do
    given_i_am_signed_as_an_admin
    when_i_search_for_a_duplicate_by("phone number")
    then_i_see_matching_duplicates_by_phone_number
  end

  it "Admin can search for duplicates by passport number" do
    given_i_am_signed_as_an_admin
    when_i_search_for_a_duplicate_by("passport number")
    then_i_see_matching_duplicates_by_passport_number
  end

  it "the view renders even where there are 'in progress' applications" do
    given_i_am_signed_as_an_admin
    when_there_are_in_progress_applications
    when_i_visit_the_duplicates_page
    then_i_see_the_in_progress_applications
  end

  def when_i_search_for_a_duplicate_by(type)
    visit duplicates_path
    case type
    when "email"
      all("a", text: "test@example.com").first.click
    when "phone number"
      all("a", text: "111222333").first.click
    when "passport number"
      all("a", text: "123456").first.click
    end
  end

  def when_there_are_in_progress_applications
    create(:application, applicant: nil, urn: nil, application_progress: nil)
  end

  def when_i_visit_the_duplicates_page
    visit duplicates_path
  end

  def then_i_see_the_in_progress_applications
    expect(page).to have_content("Duplicated Applications")
  end

  def then_i_see_matching_duplicates
    expect(page).to have_content("test@example.com")
    expect(page).to have_content("123456")
    expect(page).to have_content("654321")
    expect(page).to have_content("111222333")
    expect(page).to have_content("444555666")
  end

  def then_i_see_matching_duplicates_by_phone_number
    expect(page).to have_content("test@example.com")
    expect(page).to have_content("111222333")
  end

  def then_i_see_matching_duplicates_by_passport_number
    expect(page).to have_content("test@example.com")
    expect(page).to have_content("123456")
  end
end
