class CreateDuplicateApplications < ActiveRecord::Migration[7.0]
  def change
    create_view :duplicate_applications
  end
end
