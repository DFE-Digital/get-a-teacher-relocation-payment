# frozen_string_literal: true

class ApplicationController < ActionController::Base
  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

  before_action :check_service_open!

  delegate :application_route, to: :current_application
  helper_method :application_route

  def check_application!
    return if session["application_id"]

    redirect_to(root_path)
  end

  def current_application
    Application.in_progress.find(session["application_id"])
  end
  helper_method :current_application

  def current_applicant
    current_application.applicant
  end
  helper_method :current_applicant

  def check_teacher!
    return unless application_route != "teacher"

    redirect_to(new_applicants_application_route_path)
  end

  def check_trainee!
    return unless application_route != "salaried_trainee"

    redirect_to(new_applicants_application_route_path)
  end

  def check_service_open!
    return if request.path == "/users/sign_out" # skip this for log out page
    return if Gatekeeper.application_open?

    redirect_to(closed_path)
  end
end
