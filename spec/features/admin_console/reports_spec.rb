# frozen_string_literal: true

require "rails_helper"

describe "Reports - export to CSV" do
  include AdminHelpers

  it "exports Home Office CSV" do
    given_i_am_signed_as_an_admin
    when_i_am_in_the_reports_page

    and_i_click_on_the_home_office_csv_link

    expect(page.response_headers["Content-Type"]).to match(/text\/csv/)
    expect(page.response_headers["Content-Disposition"]).to include "attachment"
    expect(page.response_headers["Content-Disposition"]).to include 'filename="Home-Office-Report.csv"'
  end

  def and_i_click_on_the_home_office_csv_link
    click_on "Download home office report"
  end

  def when_i_am_in_the_reports_page
    visit reports_path
  end
end