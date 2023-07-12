# frozen_string_literal: true

require "rails_helper"

describe "Reports - export to CSV" do
  include AdminHelpers

  it "exports Home Office CSV" do
    given_i_am_signed_as_an_admin
    when_i_am_in_the_reports_page
    and_i_click_on_the_home_office_csv_link

    then_the_home_office_csv_report_is_downloaded
  end

  it "exports Standing Data CSV" do
    given_i_am_signed_as_an_admin
    when_i_am_in_the_reports_page
    and_i_click_on_the_standing_data_csv_link

    then_the_standing_data_csv_report_is_downloaded
  end

private

  def then_the_standing_data_csv_report_is_downloaded
    expect(page.response_headers["Content-Type"]).to match(/text\/csv/)
    expect(page.response_headers["Content-Disposition"]).to include "attachment"
    expect(page.response_headers["Content-Disposition"]).to include 'filename="Standing-Data-Report.csv"'
  end

  def then_the_home_office_csv_report_is_downloaded
    expect(page.response_headers["Content-Type"]).to match(/text\/csv/)
    expect(page.response_headers["Content-Disposition"]).to include "attachment"
    expect(page.response_headers["Content-Disposition"]).to match(/filename="Home-Office-Report.*/)
  end

  def and_i_click_on_the_home_office_csv_link
    within ".home-office" do
      click_on "Download"
    end
  end

  def and_i_click_on_the_standing_data_csv_link
    within ".standing-data" do
      click_on "Download"
    end
  end

  def when_i_am_in_the_reports_page
    visit reports_path
  end
end
