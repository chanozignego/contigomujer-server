# == Schema Information
# Schema version: 20161123145518
#
# Table name: carriers
#
#  id                     :integer          not null, primary key
#  first_name             :string
#  last_name              :string
#  vehicle                :integer
#  telephone              :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  picture                :string
#  fingerprint            :string
#  state                  :integer          default(1)
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  tokens                 :text
#  current_position       :geography({:srid point, 4326
#  device_token           :string
#  dni                    :string           default(""), not null
#

class LawSerializer < ActiveModel::Serializer
  attributes :id, :title, :file_url

  def file_url
    host = host || "localhost:3000"
    file = object.try(:file)
    if host.present? && file.present? 
      host + file.try(:url)
    end
  end

end
