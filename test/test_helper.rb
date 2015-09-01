ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

#require 'win32console'
#include Win32::Console::ANSI
#include Term::ANSIColor


require 'minitest/autorun' 
require "minitest/reporters"
Minitest::Reporters.use!


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Returns true if a test user is logged in
  def is_test_user_logged_in?
    !session[:user_id].nil?
  end
end
