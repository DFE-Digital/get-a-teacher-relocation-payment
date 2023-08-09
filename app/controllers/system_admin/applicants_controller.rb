# frozen_string_literal: true

module SystemAdmin
  class ApplicantsController < AdminController
    default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

    before_action :find_applicant, only: %i[show edit update]

    include Pagy::Backend

    def index
      results = Application.submitted
      .search(params[:search])
      .filter_by_status(params[:status])
      .order(created_at: :desc)
      @pagy, @applications = pagy(results)

      @applications = @applications.select(&:sla_breached?) if params[:sla_breached] == "true"

      respond_to do |format|
        format.html
        format.csv do
          send_data(@applications.to_csv, filename: "#{Time.zone.today}_GaIRP_applications.csv")
        end
      end
    end

    def show; end

    def edit; end

    def update
      if @progress.update(applicant_params)
        redirect_to(applicant_path(@applicant))
      else
        render(:edit)
      end
    end

  private

    def applicant_params
      params.require(:application_progress).permit(
        :initial_checks_completed_at,
        :visa_investigation_required,
        :home_office_checks_completed_at,
        :school_investigation_required,
        :school_checks_completed_at,
        :banking_approval_completed_at,
        :payment_confirmation_completed_at,
        :rejection_completed_at,
        :rejection_reason,
      )
    end

    def find_applicant
      @applicant = Applicant.find(params[:id])
      @application = @applicant.application
      @progress = @application.application_progress
    end
  end
end
