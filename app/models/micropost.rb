require 'obscenity/active_model'

class Micropost < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true,
                      length: {maximum: 140},
                      obscenity: true
end
