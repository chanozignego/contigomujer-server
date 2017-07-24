class Law < ActiveRecord::Base

  validates :title, :file, presence: true

  mount_uploader :file, FileUploader
end
