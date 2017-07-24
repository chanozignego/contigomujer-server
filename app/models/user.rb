class User < ActiveRecord::Base

  validates :name, :email, :address, presence: true

  belongs_to :town

end
