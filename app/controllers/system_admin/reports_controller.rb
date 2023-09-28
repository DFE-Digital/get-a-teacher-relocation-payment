module SystemAdmin
  class ReportsController < AdminController
    def index; end

    def show
      report = Report.call(params[:id], **report_params)
      create_audit(action: "Downloaded #{report.name} report")

      send_data(report.data, filename: report.filename)
    end

  private

    def report_params
      params.permit(:id, :status)
    end
  end
end
