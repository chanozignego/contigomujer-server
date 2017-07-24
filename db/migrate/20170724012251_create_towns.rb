class CreateTowns < ActiveRecord::Migration
  def change
    create_table :towns do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
