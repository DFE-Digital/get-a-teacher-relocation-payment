# Understanding Login Functionality

## Introduction:

The login functionality in our application is crucial for securing our platform and ensuring that only authorized individuals have access.
It is facilitated through the integration of Devise, Omniauth, and Azure AD strategy.
This document elaborates on the process of configuring and operating the login functionality, especially focusing on its interaction with Azure App Registration.

1. **Key Components**:
   - **Devise**: A flexible authentication solution for Rails based on Warden.
   - **Omniauth**: A library that standardizes multi-provider authentication for web applications.
   - **Azure Strategy**: A strategy employed by Omniauth to authenticate with Azure AD.
2. **Azure AD and App Registration**:
   - Our application connects to an Azure App Registration configured on Azure within the DfE tenant.
   - The specific app registration we use is named `get-a-teacher-relocation-payment`. With suffix of 'local', 'qa', 'staging', 'production' for each environment.
3. **Configuration for GitHub PR Review Apps**:

   - The `local` app registration is configured to work with GitHub PR review apps when adding the `deploy` label.
   - To make it work for a new PR review app deployment, update the list of redirect URIs in the Azure app registration configuration. Include the new URI corresponding to the PR number of the deployed GitHub review app.

4. **Login Process**:
   - Navigate to the login page.
   - You will be redirected to Azure for authentication. Log in using an `@education.gov.uk` email address.
   - Upon successful authentication with Azure, you get redirected back, and then the application checks against an internal list of authorized users.
   - If the email address is on the list, the user is logged in; otherwise, access is denied.
5. **Rails App Internal User List**:

   - Our Rails application maintains an internal list of users authorized to log in.
   - This list is crucial for an additional layer of access control beyond Azure authentication.

6. **Code Snippet** (For illustration):

```ruby
# config/initializers/devise.rb
Devise.setup do |config|
  config.omniauth(:azure_activedirectory_v2,
                  client_id: ENV.fetch("AZURE_CLIENT_ID", nil),
                  client_secret: ENV.fetch("AZURE_CLIENT_SECRET", nil),
                  tenant_id: ENV.fetch("AZURE_TENANT_ID", nil))
end

# app/controllers/users/omniauth_callbacks_controller.rb
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :check_service_open!

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
```

This snippet demonstrates the setup of Devise and Omniauth with the Azure strategy and a simplified user model that finds or creates a user based on the Azure authentication data.

## Conclusion:

Understanding and configuring the login functionality correctly is vital for the security and proper functioning of our application. Following the outlined steps ensures a seamless authentication process, leveraging Azure AD while maintaining an extra layer of access control through an internal user list.
