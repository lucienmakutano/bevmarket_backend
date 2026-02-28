require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  test "valid employee from fixture" do
    employee = employees(:admin_employee)
    assert employee.valid?
  end

  test "requires role" do
    employee = Employee.new(
      establishment: establishments(:bevmart),
      user: users(:unemployed_user),
      sale_point: sale_points(:warehouse_point)
    )
    assert_not employee.valid?
    assert_includes employee.errors[:role], "can't be blank"
  end

  test "belongs to establishment" do
    employee = employees(:admin_employee)
    assert_equal establishments(:bevmart), employee.establishment
  end

  test "belongs to user" do
    employee = employees(:admin_employee)
    assert_equal users(:admin_user), employee.user
  end

  test "belongs to sale_point" do
    employee = employees(:admin_employee)
    assert_equal sale_points(:warehouse_point), employee.sale_point
  end

  test "admin role" do
    assert_equal "admin", employees(:admin_employee).role
  end

  test "employee role" do
    assert_equal "employee", employees(:regular_employee).role
  end
end
