require 'obscenity/active_model'

class Micropost < ActiveRecord::Base

  MAX_IMAGE_SIZE = 5
  MAX_POST_LENGTH = 140

  belongs_to :user

  default_scope -> { order(created_at: :desc) }

  mount_uploader      :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true,
                      length: {maximum: MAX_POST_LENGTH},
                      obscenity: true
  validate :picture_size

  private

  def picture_size
    if picture.size > MAX_IMAGE_SIZE.megabytes
      errors.add(:picture, "should be less than #{MAX_IMAGE_SIZE}MB ")
    end
  end

end
