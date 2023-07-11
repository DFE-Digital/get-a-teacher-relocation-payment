# frozen_string_literal: true

require "rails_helper"

describe "Reports - export to CSV" do
  include AdminHelpers

  it "exports Home Office CSV" do
    given_i_am_signed_as_an_admin
    when_i_am_in_the_reports_page
  end

  def when_i_am_in_the_reports_page
    visit reports_path
  end
end
