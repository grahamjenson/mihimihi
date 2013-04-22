class ImageDatum < ActiveRecord::Base
  attr_accessible :image, :link, :title, :years_ago
  mount_uploader :image, ImageUploader
  
end
