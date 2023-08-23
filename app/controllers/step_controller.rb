class StepController < ApplicationController
  before_action :check_service_open!,
                :current_step

  def new
    render(current_step.template)
  end

  def update
    service = UpdateForm.call(current_step, step_params)
    if service.success?
      update_session(current_step)
      redirect_to(StepFlow.next_step_path(current_step))
    else
      render(current_step.template)
    end
  end

  alias_method :create, :update

private

  def current_step
    @step ||= StepFlow.current_step(current_form, params[:name])
    redirect_to(root_path) unless @step
    @step
  end

  def step_params
    params.fetch(@step.class.name.underscore, {}).permit(*@step.fields)
  end

  def update_session(step)
    session["form_id"] = step.form.id
  end
end
