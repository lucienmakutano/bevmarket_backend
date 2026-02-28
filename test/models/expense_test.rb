require "test_helper"

class ExpenseTest < ActiveSupport::TestCase
  test "valid expense from fixture" do
    expense = expenses(:office_expense)
    assert expense.valid?
  end

  test "requires amount" do
    expense = Expense.new(
      reason: "Test",
      user: users(:admin_user),
      sale_point: sale_points(:warehouse_point),
      establishment: establishments(:bevmart)
    )
    assert_not expense.valid?
    assert_includes expense.errors[:amount], "can't be blank"
  end

  test "requires reason" do
    expense = Expense.new(
      amount: 100,
      user: users(:admin_user),
      sale_point: sale_points(:warehouse_point),
      establishment: establishments(:bevmart)
    )
    assert_not expense.valid?
    assert_includes expense.errors[:reason], "can't be blank"
  end

  test "belongs to user" do
    expense = expenses(:office_expense)
    assert_equal users(:admin_user), expense.user
  end

  test "belongs to sale_point" do
    expense = expenses(:office_expense)
    assert_equal sale_points(:warehouse_point), expense.sale_point
  end

  test "belongs to establishment" do
    expense = expenses(:office_expense)
    assert_equal establishments(:bevmart), expense.establishment
  end
end
