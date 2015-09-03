class User < ActiveRecord::Base
  
  attr_accessor :remember_token
  
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
  def remember
    self.remember_token = User.new_token()
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
                        
  #Class methods
                        
  #Returns hash digest of the given string, used in unit tests. 
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST:
                                                  BCrypt::Engine::cost
    BCrypt::Password.create(string, cost: cost)              
  end       
  
  #Returns random token (Used for cookies)
  def User.new_token
    SecureRandom.urlsafe_base64
  end            
end
