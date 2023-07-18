require "rails_helper"

RSpec.describe "SSO" do
  describe "GET /dashboard" do
    it "redirects to Azure login when user is not authenticated" do
      get dashboard_path

      expect(response).to redirect_to(user_azure_activedirectory_v2_omniauth_authorize_path)
    end

    it "allows user to log in and redirects to last path they were trying to access" do
      user = create(:user)

      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:azure_activedirectory_v2] = OmniAuth::AuthHash.new({
        info: { email: user.email },
      })

      get users_path

      post user_azure_activedirectory_v2_omniauth_callback_path

      expect(response).to redirect_to(users_path)
      get users_path
      expect(response).to be_successful
    end

    it "redirects to root_path when user successfully logs in but does not have a user" do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:azure_activedirectory_v2] = OmniAuth::AuthHash.new({
        info: { email: "unauthorize_user@example.com" },
      })

      post user_azure_activedirectory_v2_omniauth_callback_path

      expect(response).to redirect_to(root_path)
    end

    it "allows user to log out" do
      user = create(:user)

      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:azure_activedirectory_v2] = OmniAuth::AuthHash.new({
        info: { email: user.email },
      })

      post user_azure_activedirectory_v2_omniauth_callback_path
      follow_redirect!

      get destroy_user_session_path
      follow_redirect!

      expect(response.body).to include("Signed out successfully.")
    end
  end
end
