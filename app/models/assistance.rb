class Assistance < ActiveRecord::Base

  enum state: {
    pending: 0, 
    accepted: 1, 
    finalized: 2, 
    canceled: 3
  }

  belongs_to :user
  belongs_to :town
  belongs_to :admin_user
  
end
