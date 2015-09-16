class User < ActiveRecord::Base
  
  attr_accessor :remember_token, :activation_token, :reset_token  
  
  MIN_PWD_LEN = 6
  MAX_NAME_LEN = 50
  MAX_EMAIL_LEN = 255
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  before_save {self.email = email.downcase}
  before_create :create_activation_digest
  
  
  validates :name,  presence: true, 
                    length: {maximum: MAX_NAME_LEN}
  
  validates :email, presence: true, 
                    length: {maximum: MAX_EMAIL_LEN}, 
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  
  has_secure_password
  validates :password,  presence: true,
                        length: {minimum: MIN_PWD_LEN},
                        allow_nil: true
  def remember
    self.remember_token = User.new_token()
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest") 
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end
  
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_digest_at, Time.zone.now)        
  end
  
  def send_reset_email
    UserMailer.reset_password(self).deliver_now
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
  
  #Private methods
  private
  
     def create_activation_digest
       self.activation_token  = User.new_token
       self.activation_digest = User.digest(activation_token)
     end
end
