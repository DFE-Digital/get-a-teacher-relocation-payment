namespace :roles do
  desc "Create default roles"
  task create_defaults: :environment do
    Role::ROLES_LIST.each do |role_name|
      Role.find_or_create_by(name: role_name)
    end
  end
end
