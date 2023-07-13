# frozen_string_literal: true

module SystemAdmin
  class SettingsController < AdminController
    default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

    def edit
      @settings = AppSettings.current
    end
  end
end
