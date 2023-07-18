class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def azure_activedirectory_v2
    response_params = request.env["omniauth.auth"]["info"]
    @user = User.find_by(email: response_params["email"])

    if @user
      sign_in_and_redirect(@user, event: :authentication)
    else
      flash[:danger] = t("omniauth_callbacks.no_account")
      redirect_back(fallback_location: root_path)
    end
  end

  def after_sign_in_path_for(_resource)
    dashboard_path
  end

  def new_session_path(_scope)
    user_azure_activedirectory_v2_omniauth_authorize_path
  end
end
