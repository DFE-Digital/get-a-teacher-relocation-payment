# frozen_string_literal: true

require "rails_helper"

module Reports
  describe HomeOffice do
    subject(:report) { described_class.new }

    it "returns the name of the Report" do
      expect(report.name).to eq("Home-Office-Report.csv")
    end
  end
end
