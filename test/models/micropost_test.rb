require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  MAX_POST_LENGTH = Micropost::MAX_POST_LENGTH

  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = " "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * (MAX_POST_LENGTH + 1)
    assert_not @micropost.valid?
  end

  test "content should not be obscene" do
    @micropost.content = "shit"
    assert_not @micropost.valid?
  end

  test "Clean 140 characters is valid" do
    @micropost.content = "a" * MAX_POST_LENGTH
    assert @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

end
