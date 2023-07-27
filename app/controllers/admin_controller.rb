# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authenticate_user!

  skip_before_action :check_service_open!

  layout "admin"

protected

  def authenticate_user!
    if user_signed_in?
      super
    else
      session[:user_return_to] = request.fullpath
      redirect_to(user_azure_activedirectory_v2_omniauth_authorize_path)
    end
  end
end
