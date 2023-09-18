class AddApplicantIpAddress < ActiveRecord::Migration[7.0]
  def change
    add_column :applicants, :ip_address, :string
  end
end
