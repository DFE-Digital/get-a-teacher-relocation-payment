# frozen_string_literal: true

module Applicants
  class SubmissionsController < ApplicationController
    before_action :check_application!

    def show
      @application = Application.find(session[:application_id])

      session[:application_id] = nil
    end
  end
end
