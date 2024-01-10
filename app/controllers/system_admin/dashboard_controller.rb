module SystemAdmin
  class DashboardController < AdminController
    def show
      @kpis = Kpis.new(**kpi_params.merge(window_params))
    rescue ArgumentError => e
      flash[:alert] = e.message
      redirect_to(dashboard_path)
    end

  private

    def kpi_params
      params
        .fetch(:date_range, {})
        .permit(:unit, :range_start, :range_end)
        .to_hash
        .symbolize_keys
    end

    def window_params
      { window: params[:window] }
    end
  end
end
