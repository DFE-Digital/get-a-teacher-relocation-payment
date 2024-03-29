module SystemAdmin
  class ReportsController < AdminController
    before_action :check_user_roles

    def index; end

    def show
      report = Report.call(params[:id], **report_params)
      send_data(report.data, filename: report.filename)
    end

    def reset
      Report.reset(params[:id], **reset_report_params)
      redirect_to(audits_path)
    end

  private

    def report_params
      params.permit(:id, :status).merge(user: current_user)
    end

    def reset_report_params
      params.permit(:id, :status, :timestamp, :arid).merge(user: current_user)
    end

    def check_user_roles
      case params[:id]
      when "home_office", "standing_data", "payroll"
        unless current_user.has_role?(:manager)
          redirect_to(root_path, alert: t("errors.access_denied"))
        end
      when "applications", "qa"
        unless current_user.has_role?(:admin)
          redirect_to(root_path, alert: t("errors.access_denied"))
        end
      end
    end
  end
end
