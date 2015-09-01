require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "login with invalid info" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: {email: "", password: ""}
    assert_template 'sessions/new'
    assert_not( flash.empty?, "Flash should exist" )
    get root_path
    assert( flash.empty?, "Flash should be empty" )
  end
  
  test "login with valid info" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: {email: @user.email, password: 'password'}
    assert_redirected_to @user
    follow_redirect!
    assert_template('users/show', "Not on user home page")
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user) 
  end
  
  
end
