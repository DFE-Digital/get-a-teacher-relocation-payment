# frozen_string_literal: true

module SystemAdmin
  class SettingsController < AdminController
    default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

    def edit
      @app_settings = AppSettings.current
    end
  end
end
