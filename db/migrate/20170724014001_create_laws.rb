class CreateLaws < ActiveRecord::Migration
  def change
    create_table :laws do |t|
      t.string :title, null: false
      t.string :file, null: false

      t.timestamps null: false
    end
  end
end
