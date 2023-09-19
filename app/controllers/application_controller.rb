# frozen_string_literal: true

class ApplicationController < ActionController::Base
  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  before_action :check_service_open!

  def check_service_open!
    return if request.path == destroy_user_session_path # skip this for log out page
    return if Gatekeeper.application_open?

    redirect_to(closed_path)
  end

  def current_form
    @current_form ||= Form.find_by(id: session["form_id"])
  end
end
