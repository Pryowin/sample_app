require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
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
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 250 + "example.com"
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
  
  
end
