# spec/features/duplicates_search_spec.rb
require "rails_helper"

RSpec.describe "Duplicates Search" do
  include AdminHelpers

  let!(:applicant_one) { build(:applicant, email_address: "test@example.com", passport_number: "123456", phone_number: "111222333") }
  let!(:applicant_two) { build(:applicant, email_address: "test@example.com", passport_number: "654321", phone_number: "444555666") }
  let!(:applicant_three) { build(:applicant, email_address: "test1@example.com", passport_number: "987654", phone_number: "444555666") }
  let!(:applicant_four) { build(:applicant, email_address: "test2@example.com", passport_number: "123456", phone_number: "999999999") }

  before do
    create(:application, :submitted, applicant: applicant_one)
    create(:application, :submitted, applicant: applicant_two)
    create(:application, :submitted, applicant: applicant_three)
    create(:application, :submitted, applicant: applicant_four)
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

  it "shows duplicates only once even if they match multiple times" do
    given_i_am_signed_as_an_admin
    when_there_are_in_progress_applications
    when_i_visit_the_duplicates_page
    then_i_see_the_in_progress_applications_only_once
  end

  def when_i_search_for_a_duplicate_by(type)
    visit duplicates_path
    case type
    when "email"
      all("a", text: applicant_one.email_address).first.click
    when "phone number"
      all("a", text: applicant_two.phone_number).first.click
    when "passport number"
      all("a", text: applicant_four.passport_number).first.click
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
    expect(page).to have_content("test1@example.com")
    expect(page).to have_content("444555666")
  end

  def then_i_see_matching_duplicates_by_passport_number
    expect(page).to have_content("test@example.com")
    expect(page).to have_content("123456")
  end

  def then_i_see_the_in_progress_applications_only_once
    rows = all("table.duplicates-table tbody tr")
    expect(rows.count).to eq(4)

    urns_list = DuplicateApplication.all.pluck(:urn).uniq
    table_urns = rows.map { |row| row.all("td")[0].text }

    expect(urns_list).to match_array(table_urns)
  end
end
