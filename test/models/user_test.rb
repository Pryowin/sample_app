require 'test_helper'



class UserTest < ActiveSupport::TestCase
  
  MIN_PWD_LEN = User::MIN_PWD_LEN
  MAX_NAME_LEN = User::MAX_NAME_LEN
  MAX_EMAIL_LEN = User::MAX_EMAIL_LEN
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                    password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end
  
  test "name should not be too long" do
    @user.name = "a" * (MAX_NAME_LEN + 1)
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    domain = "@example.com"
    @user.email = "a" * (MAX_EMAIL_LEN - domain.length + 1) + domain
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    validAddresses = %w[user@example.com USER@foo.COM A_Us-er@foo.bar.org first.last@foo.uk alice+bob@baz.cn]
    validAddresses.each do |validAddress|
      @user.email = validAddress
      assert @user.valid?, "#{validAddress.inspect} should be valid" 
    end 
  end
  
  test "email validation should reject invalid addresses" do
    invalidAddresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
    invalidAddresses.each do |invalidAddress|
      @user.email = invalidAddress
      assert_not @user.valid?, "#{invalidAddress.inspect} should be invalid" 
    end 
  end
  
  test "email address should be unique" do
    dupUser = @user.dup
    dupUser.email = @user.email.upcase
    @user.save
    assert_not dupUser.valid?
  end

  test "password should not be blank" do
    @user.password = " " * MIN_PWD_LEN
    assert_not @user.valid?
  end

  test "password should be at least minimum length" do
    @user.password = "a" * (MIN_PWD_LEN - 1)
    @user.password_confirmation = "a" * (MIN_PWD_LEN - 1)
    
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
end
