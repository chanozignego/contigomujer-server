class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :message_type
      t.integer :receiver_type, null: false
      t.integer :receiver_id, null: false
      t.boolean :read, null: false, default: false
      t.boolean :viewed, null: false, default: false
      t.jsonb   :data, default: {}

      t.timestamps null: false
    end
  end
end
