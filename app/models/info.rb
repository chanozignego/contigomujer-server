class Info < ActiveRecord::Base

  validates :title, :description, :town, presence: true

  belongs_to :town
end
