module SystemAdmin
  class ReportsController < AdminController
    def index; end

    def show
      report = Reports::HomeOffice.new
      headers["Content-Type"] = "text/csv"

      send_data(report.data, filename: report.name)
    end
  end
end
