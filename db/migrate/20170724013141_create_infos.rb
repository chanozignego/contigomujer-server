class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|

      t.string :title, null: false
      t.string :description, null: false
      t.belongs_to :town

      t.timestamps null: false
    end
  end
end
