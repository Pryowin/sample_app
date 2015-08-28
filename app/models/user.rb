class User < ActiveRecord::Base
  
  
  MIN_PWD_LEN = 6
  MAX_NAME_LEN = 50
  MAX_EMAIL_LEN = 255
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  before_save {self.email = email.downcase}
  
  
  
  validates :name,  presence: true, 
                    length: {maximum: MAX_NAME_LEN}
  
  validates :email, presence: true, 
                    length: {maximum: MAX_EMAIL_LEN}, 
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  
  has_secure_password
  validates :password,  presence: true,
                        length: {minimum: MIN_PWD_LEN}
  
                    
end
