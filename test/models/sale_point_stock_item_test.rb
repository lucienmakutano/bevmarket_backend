require "test_helper"

class SalePointStockItemTest < ActiveSupport::TestCase
  test "valid sale_point_stock_item from fixture" do
    spsi = sale_point_stock_items(:warehouse_beer)
    assert spsi.valid?
  end

  test "requires quantity" do
    spsi = SalePointStockItem.new(
      stock_item: stock_items(:beer_stock),
      sale_point: sale_points(:warehouse_point)
    )
    assert_not spsi.valid?
    assert_includes spsi.errors[:quantity], "can't be blank"
  end

  test "belongs to stock_item" do
    spsi = sale_point_stock_items(:warehouse_beer)
    assert_equal stock_items(:beer_stock), spsi.stock_item
  end

  test "belongs to sale_point" do
    spsi = sale_point_stock_items(:warehouse_beer)
    assert_equal sale_points(:warehouse_point), spsi.sale_point
  end
end
