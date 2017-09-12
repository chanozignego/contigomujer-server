class Message < ActiveRecord::Base

  enum receiver_type: {  
    user: 0,                    # --> User
    auxiliary: 1,               # --> Auxiliary
    admin_user: 2               # --> AdminUser
  }

  enum message_type: {  
    request_assistance: 0,        # assistance required by user (for auxiliaries) --> request_assistance
    assistance_canceled: 1,       # assistance canceled by user (for auxiliaries) --> asistance_canceled
    answer_question: 2            # answer question by user (for users) --> answer_question
  }

end
