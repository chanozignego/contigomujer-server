module ShortestResetPasswordToken

  extend ActiveSupport::Concern

  def set_reset_password_token
    token = Devise.friendly_token(6)
    self.reset_password_token   = token
    self.reset_password_sent_at = Time.now.utc
    save(validate: false)
    token
  end

end

