class AddTownFieldToAdminUser < ActiveRecord::Migration
  def change
    add_reference :admin_users, :town, index: true
  end
end
