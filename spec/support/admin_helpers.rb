module AdminHelpers
  def given_i_am_signed_as_an_admin
    sign_in create(:user)
  end
end
