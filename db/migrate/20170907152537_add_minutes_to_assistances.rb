class AddMinutesToAssistances < ActiveRecord::Migration
  def change
    add_column :assistances, :minutes, :integer
  end
end
