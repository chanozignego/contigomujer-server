class UserSerializer < ActiveModel::Serializer
  attributes  :id, :name, :email, :street, :address, :number, :apartment, 
              :town, :town_id, :height, :age

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
