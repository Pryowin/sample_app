require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup info" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: {  name:                   "",
                                email:                  "dburke@com",
                                password:               "foo",
                                password_confirmation:  "bar"
      }  
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors',6
  end
  
  test "valid signup info" do
    get signup_path
    assert_difference 'User.count',1 do
      post_via_redirect users_path, user: {   name:                   "David Burke",
                                              email:                  "dburke@amberfire.net",
                                              password:               "foobar",
                                              password_confirmation:  "foobar"
      }  
    end
    assert_template 'users/show'
    assert_not flash.empty?
  end
  
end 