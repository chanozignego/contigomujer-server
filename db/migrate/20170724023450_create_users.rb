class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :name, null: false
      t.string :email, null: false
      t.string :phone
      t.integer :height
      t.integer :age
      t.string :address, null: false
      t.belongs_to :town

      t.timestamps null: false
    end
  end
end
