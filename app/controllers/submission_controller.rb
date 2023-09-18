class SubmissionController < ApplicationController
  before_action :check_service_open!
  before_action :redirect_to_root_path_when_no_form, only: %i[summary create]

  def summary
    @summary = Summary.new(current_form)
  end

  def show
    @application = Application.find_by(id: session["application_id"])
    if @application
      render(:show)
    else
      redirect_to(summary_path)
    end
  end

  def create
    service = SubmitForm.call(current_form, request.remote_ip)
    if service.success?
      update_session(service)
      redirect_to(submission_path)
    else
      @summary = Summary.new(service.form)
      render(:summary)
    end
  end

private

  def update_session(service)
    session["application_id"] = service.application.id
    session.delete("form_id")
  end

  def redirect_to_root_path_when_no_form
    redirect_to(root_path) unless current_form
  end
end
