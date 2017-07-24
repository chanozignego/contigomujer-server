module Admin
  class AdminUsersController < Admin::ApplicationController
    include ChangePasswordMethods
  end
end
