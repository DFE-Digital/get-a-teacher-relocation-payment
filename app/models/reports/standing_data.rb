# frozen_string_literal: true

module Reports
  class StandingData
    def name
      "Standing-Data-Report.csv"
    end

    def csv
      CSV.generate do |csv|
        csv << header
        rows.each { |row| csv << row }
      end
    end

  private

    def rows
      []
    end

    def header
      []
    end
  end
end
