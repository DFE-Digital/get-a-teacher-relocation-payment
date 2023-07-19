class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def azure_activedirectory_v2
    response_params = request.env["omniauth.auth"]["info"]
    @user = User.find_by(email: response_params["email"])

    if @user
      sign_in_and_redirect(@user, event: :authentication)
    else
      flash[:alert] = t("omniauth_callbacks.no_account")
      redirect_to(root_path)
    end
  end

  def after_omniauth_failure_path_for(_scope)
    root_path
  end
end
