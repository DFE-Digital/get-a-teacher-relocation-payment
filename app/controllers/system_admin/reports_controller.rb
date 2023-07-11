module SystemAdmin
  class ReportsController < AdminController
    def index; end

    def show
        headers["Content-Type"] = "text/csv"
        headers["Content-Disposition"] = 'attachment; filename="Home-Office-Report.csv"'

        send_data(csv_data, filename: 'Home-Office-Report.csv')
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
