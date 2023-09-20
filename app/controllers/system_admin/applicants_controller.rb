# frozen_string_literal: true

module SystemAdmin
  class ApplicantsController < AdminController
    default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

    before_action :find_applicant, only: %i[show edit update]

    include Pagy::Backend

    def index
      results = Application.all
      .search(params[:search])
      .filter_by_status(params[:status])
      .order(created_at: :desc)

      results = results.select(&:sla_breached?) if params[:sla_breached] == "true"

      @pagy, @applications = pagy_array(results)
      session[:filter_status] = params[:status]
      session[:application_ids] = @applications.map(&:id)
    end

    def download_qa_csv
      status = session[:filter_status]
      application_ids = session[:application_ids]

      applications = Application.where(id: application_ids).reject(&:qa?)

      applications.each(&:mark_as_qa!)

      report = Reports::QaReport.new(applications, status)
      create_audit(action: "Downloaded QA CSV report (#{status.humanize})")
      send_data(report.csv, filename: report.name)
    end

    def duplicates
      @pagy, @duplicates = pagy(DuplicateApplication.search(params[:search]).select("DISTINCT ON (urn) *"))
    end

    def show; end

    def edit; end

    def update
      @validator = ApplicationProgressValidator.new(@progress, applicant_params)

      if @validator.valid?
        @progress.update!(applicant_params)
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
        :rejection_details,
      )
    end

    def find_applicant
      @applicant = Applicant.find(params[:id])
      @application = @applicant.application
      @progress = @application.application_progress
    end
  end
end
