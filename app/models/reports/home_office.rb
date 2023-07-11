# frozen_string_literal: true

module Reports
  class HomeOffice
    def name
      "Home-Office-Report.csv"
    end

    def data
      CSV.generate do |csv|
        # Add your CSV content here
        csv << ["Header 1", "Header 2", "Header 3"]
        csv << ["Data 1", "Data 2", "Data 3"]
      end
    end
  end
end
