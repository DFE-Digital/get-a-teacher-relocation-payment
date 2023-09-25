module SystemAdmin
  class ReportsController < AdminController
    def index; end

    def show
      service = Report.call(params[:id], **report_params)
      create_audit(action: "Downloaded #{service.report_name} report")

      send_data(service.data, filename: service.filename)
    end

  private

    def report_params
      params.permit(:id, :status)
    end
  end
end
