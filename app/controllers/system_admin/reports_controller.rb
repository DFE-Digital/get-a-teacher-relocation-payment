module SystemAdmin
  class ReportsController < AdminController
    def index; end

    def show
      report = find_report(params[:id])
      create_audit(action: "Downloaded #{report.class.to_s.capitalize} report")

      send_data(report.csv, filename: report.name)
    end

  private

    def find_report(report_id)
      {
        home_office: Reports::HomeOffice.new,
        standing_data: Reports::StandingData.new,
        payroll: Reports::Payroll.new,
      }.with_indifferent_access.fetch(report_id)
    end
  end
end
