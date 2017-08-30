class AddAddressFields < ActiveRecord::Migration
  def change
    add_column :users, :street, :string
    add_column :users, :number, :string
    add_column :users, :apartment, :string
  end
end
