module SystemAdmin
  class ReportsController < AdminController
    def index; end

    def show
      report = find_report(params[:id])

      send_data(report.csv, filename: report.name)
    end

  private

    def find_report(report_id)
      {
        home_office: Reports::HomeOffice.new,
      }.with_indifferent_access.fetch(report_id)
    end
  end
end
