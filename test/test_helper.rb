ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'



require 'minitest/autorun' 
require "minitest/reporters"
Minitest::Reporters.use!

#Added this line to ensure latest migrations are applied to test schema
ActiveRecord::Migration.maintain_test_schema!


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Returns true if a test user is logged in
  def is_test_user_logged_in?
    !session[:user_id].nil?
  end
  
  def log_in_as(user, options={})
    password    = options[:password] || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post login_path, session: { email:        user.email,
                                  password:     password,
                                  remember_me:  remember_me
      }
    else
      session[:user_id] = user.id
    end
  end
  
  
  private
    
    def integration_test?
      defined?(post_via_redirect)
    end
end
