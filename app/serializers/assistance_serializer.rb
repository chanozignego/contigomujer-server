class AssistanceSerializer < ActiveModel::Serializer
  attributes  :id, :town, :town_id, :user, :user_id, :state, 
              :full_address, :user_name, :user_phone, :minutes

  def full_address
    "#{object.address}, #{object.dpto}"
  end

  def user_name
    object.user.try(:name)
  end 

  def user_phone
    object.user.try(:phone)
  end

end
