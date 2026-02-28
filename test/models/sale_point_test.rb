require "test_helper"

class SalePointTest < ActiveSupport::TestCase
  test "valid sale_point from fixture" do
    sale_point = sale_points(:warehouse_point)
    assert sale_point.valid?
  end

  test "belongs to establishment" do
    sale_point = sale_points(:warehouse_point)
    assert_equal establishments(:bevmart), sale_point.establishment
  end

  test "has one warehouse" do
    sale_point = sale_points(:warehouse_point)
    assert_equal warehouses(:main_warehouse), sale_point.warehouse
  end

  test "has one truck" do
    sale_point = sale_points(:truck_point)
    assert_equal trucks(:delivery_truck), sale_point.truck
  end

  test "has many sales" do
    sale_point = sale_points(:warehouse_point)
    assert_includes sale_point.sales, sales(:first_sale)
  end

  test "has many expenses" do
    sale_point = sale_points(:warehouse_point)
    assert_includes sale_point.expenses, expenses(:office_expense)
  end

  test "warehouse type" do
    assert_equal "warehouse", sale_points(:warehouse_point).sale_point_type
  end

  test "truck type" do
    assert_equal "truck", sale_points(:truck_point).sale_point_type
  end
end
