# frozen_string_literal: true

module Applicants
  class ApplicationSummaryController < ApplicationController
    before_action :check_application!

    def new
      @summary = Summary.new(application: current_application)
    end

    def create
      SubmitApplication.new(current_application).run

      redirect_to(applicants_submission_path)
    end
  end
end
