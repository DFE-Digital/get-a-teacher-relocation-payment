module SystemAdmin
  class ReportsController < AdminController
    before_action :check_user_roles

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

    def check_user_roles
      case params[:id]
      when "home_office", "standing_data", "payroll"
        unless current_user.has_role?(:manager)
          redirect_to(root_path, alert: "You do not have permission to access this page")
        end
      when "applications", "qa"
        unless current_user.has_role?(:admin)
          redirect_to(root_path, alert: "You do not have permission to access this page")
        end
      end
    end
  end
end
