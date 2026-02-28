require "test_helper"

class WarehouseTest < ActiveSupport::TestCase
  test "valid warehouse from fixture" do
    warehouse = warehouses(:main_warehouse)
    assert warehouse.valid?
  end

  test "requires name" do
    warehouse = Warehouse.new(location: "Somewhere", sale_point: sale_points(:warehouse_point))
    assert_not warehouse.valid?
    assert_includes warehouse.errors[:name], "can't be blank"
  end

  test "requires location" do
    warehouse = Warehouse.new(name: "Test", sale_point: sale_points(:warehouse_point))
    assert_not warehouse.valid?
    assert_includes warehouse.errors[:location], "can't be blank"
  end

  test "belongs to sale_point" do
    warehouse = warehouses(:main_warehouse)
    assert_equal sale_points(:warehouse_point), warehouse.sale_point
  end
end
