class NotificationManager

  # assistance required by user (for auxiliaries) --> request_assistance
  def self.notificate_request_assistance assistance, auxiliary
    token = offer.carrier.try(:device_token)
    data = {}
    NotificationManager.create_message(:request_assistance, :auxiliary, auxiliary.try(:id), data)
    
    # TODO: Implement FCM
    # FCM::API.send(token, data)
  end

  # assistance canceled by user (for auxiliaries) --> asistance_canceled
  def self.notificate_assistance_canceled assistance, auxiliary
    token = auxiliary.try(:device_token)
    data = {}

    NotificationManager.create_message(:assistance_canceled, :auxiliary, auxiliary.try(:id), data)
    
    # TODO: Implement FCM
    # FCM::API.send(token, data)
  end

  # TODO: later!!!
  # answer question by user (for users) --> answer_question
  def self.notificate_answer_question question, user
    token = offer.carrier.try(:device_token)
    data = {}

    NotificationManager.create_message(:answer_question, :user, user.try(:id), data)
    
    # TODO: Implement FCM
    # FCM::API.send(token, data)
  end


  private 
    def self.create_message type, receiver_type, receiver_id, data
      message = Message.new(message_type: type, receiver_type: receiver_type, receiver_id: receiver_id, data: data)
      message.save
    end
end



