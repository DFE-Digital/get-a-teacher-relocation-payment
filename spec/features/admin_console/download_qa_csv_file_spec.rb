require "rails_helper"

describe "Download QA CSV functionality" do
  include AdminHelpers

  it "shows the 'Download QA CSV' button only if a status filter is applied" do
    given_there_are_few_applications
    given_i_am_signed_as_an_admin
    when_i_am_in_the_applications_list_page
    then_i_should_not_see_the_download_button
    when_i_filter_by_a_status
    then_i_should_see_the_download_button
  end

  it "marks applications as qa before generating the csv" do
    given_there_are_few_applications
    given_i_am_signed_as_an_admin
    when_i_am_in_the_applications_list_page
    when_i_filter_by_a_status
    when_i_download_the_csv

    then_all_applications_should_be_marked_as_qa
  end

  it "generates an empty csv when downloaded twice consecutively" do
    given_there_are_few_applications
    given_i_am_signed_as_an_admin
    when_i_am_in_the_applications_list_page
    when_i_filter_by_a_status
    when_i_download_the_csv
    when_i_am_in_the_applications_list_page
    when_i_filter_by_a_status
    when_i_download_the_csv_again

    then_csv_should_be_empty
  end

  def given_there_are_few_applications
    create_list(:application, 5)
  end

  def when_i_am_in_the_applications_list_page
    visit(applicants_path)
  end

  def when_i_filter_by_a_status
    select "Initial checks", from: "status"
    click_button "Search"
  end

  def then_i_should_not_see_the_download_button
    expect(page).not_to have_link("Download QA CSV")
  end

  def then_i_should_see_the_download_button
    expect(page).to have_link("Download QA CSV")
  end

  def when_i_download_the_csv
    click_link "Download QA CSV"
  end

  def when_i_download_the_csv_again
    when_i_download_the_csv
  end

  def then_all_applications_should_be_marked_as_qa
    Application.all.each do |app|
      expect(app.reload.qa?).to be(true)
    end
  end

  def then_csv_should_be_empty
    expect(page.body.lines.count).to eq(1)
  end
end
