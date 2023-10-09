class RenameRejectionDetailsToComments < ActiveRecord::Migration[7.0]
  def change
    rename_column :application_progresses, :rejection_details, :comments
  end
end
