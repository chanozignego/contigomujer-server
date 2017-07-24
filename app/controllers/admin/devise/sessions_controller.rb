class Admin::Devise::SessionsController < Devise::SessionsController
  layout 'administrate/sign_in'

  def after_sign_in_path_for(admin_user)
    admin_root_path
  end
end