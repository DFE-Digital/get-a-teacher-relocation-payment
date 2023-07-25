# frozen_string_literal: true

module SystemAdmin
  class SettingsController < AdminController
    default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

    def edit
      @app_settings = AppSettings.current
    end

    def update
      @app_settings = AppSettings.current
      @app_settings.update!(app_settings_params)

      redirect_to(edit_settings_path)
    end

  private

    def app_settings_params
      params.require(:app_settings).permit(
        :"service_start_date(1i)",
        :"service_start_date(2i)",
        :"service_start_date(3i)",
        :"service_end_date(1i)",
        :"service_end_date(2i)",
        :"service_end_date(3i)",
      )
    end
  end
end
