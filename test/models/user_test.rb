require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user from fixture" do
    user = users(:admin_user)
    assert user.valid?
  end

  test "requires name" do
    user = User.new(email: "test@example.com", password: "password123")
    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "requires email" do
    user = User.new(name: "Test", password: "password123")
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "email must be unique" do
    user = User.new(name: "Dup", email: users(:admin_user).email, password: "password123")
    assert_not user.valid?
  end

  test "has many expenses" do
    user = users(:admin_user)
    assert_respond_to user, :expenses
  end

  test "has many sales" do
    user = users(:admin_user)
    assert_includes user.sales, sales(:first_sale)
  end

  test "has one employee" do
    user = users(:admin_user)
    assert_equal employees(:admin_employee), user.employee
  end

  test "default is_employed is false" do
    user = User.create!(name: "New", email: "new@example.com", password: "password123")
    assert_equal false, user.reload.is_employed
  end

  test "password must be at least 6 characters" do
    user = User.new(name: "Test", email: "short@example.com", password: "12345")
    assert_not user.valid?
    assert user.errors[:password].any?
  end
end
