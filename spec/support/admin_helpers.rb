module AdminHelpers
  def given_i_am_signed_with_role(role_name)
    role = Role.find_or_create_by(name: role_name)
    user = create(:user)
    user.add_role(role.name)
    sign_in user
  end
end
