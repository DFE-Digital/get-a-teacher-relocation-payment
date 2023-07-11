module SystemAdmin
  class ReportsController < AdminController
    def index; end

    def show
      report = Reports::HomeOffice.new
      headers["Content-Type"] = "text/csv"

      send_data(csv_data, filename: report.name)
    end

    def csv_data
      # Generate your CSV data using the CSV module or any other method
      CSV.generate do |csv|
        # Add your CSV content here
        csv << ["Header 1", "Header 2", "Header 3"]
        csv << ["Data 1", "Data 2", "Data 3"]
      end
    end
  end
end
