class CreateAssistances < ActiveRecord::Migration
  def change
    create_table :assistances do |t|
      t.belongs_to :user
      t.belongs_to :town
      t.integer :state, null: false, default: 0
      t.string :address
      t.string :dpto
      t.belongs_to :admin_user
      t.timestamps null: false
    end
  end
end
