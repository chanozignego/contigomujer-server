class Auxiliary < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User
  include ShortestResetPasswordToken

  belongs_to :town
  belongs_to :admin_user
end
