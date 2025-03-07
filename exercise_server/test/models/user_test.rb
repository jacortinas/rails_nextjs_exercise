require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "requires an email and password" do
    user = User.new
    assert_not user.save
    assert_equal ["can't be blank"], user.errors[:email]
    assert_equal ["can't be blank"], user.errors[:password]
  end

  test "has many access grants" do
    assert_kind_of ActiveRecord::Associations::CollectionProxy, User.new.access_grants
  end

  test "has many access tokens" do
    assert_kind_of ActiveRecord::Associations::CollectionProxy, User.new.access_tokens
  end
end
