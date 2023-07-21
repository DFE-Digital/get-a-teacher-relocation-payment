class ChangeEmailColumnTypeToCitext < ActiveRecord::Migration[7.0]
  def up
    change_column(:users, :email, :citext)
  end

  def down
    change_column(:users, :email, :string)
  end
end
