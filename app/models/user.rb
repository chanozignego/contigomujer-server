class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
  include ShortestResetPasswordToken

  validates :name, :email, :address, presence: true

  belongs_to :town

  def to_s
    name
  end

end
