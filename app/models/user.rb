class User < ActiveRecord::Base

  validates :name, :email, :address, presence: true

  belongs_to :town

  def to_s
    name
  end

end
