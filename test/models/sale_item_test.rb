require "test_helper"

class SaleItemTest < ActiveSupport::TestCase
  test "valid sale_item from fixture" do
    sale_item = sale_items(:beer_sale_item)
    assert sale_item.valid?
  end

  test "requires quantity" do
    sale_item = SaleItem.new(
      sale: sales(:first_sale),
      stock_item: stock_items(:beer_stock),
      unit_sale_price: 600
    )
    assert_not sale_item.valid?
    assert_includes sale_item.errors[:quantity], "can't be blank"
  end

  test "requires unit_sale_price" do
    sale_item = SaleItem.new(
      sale: sales(:first_sale),
      stock_item: stock_items(:beer_stock),
      quantity: 5
    )
    assert_not sale_item.valid?
    assert_includes sale_item.errors[:unit_sale_price], "can't be blank"
  end

  test "unit_sale_price must be greater than 0" do
    sale_item = SaleItem.new(
      sale: sales(:first_sale),
      stock_item: stock_items(:beer_stock),
      quantity: 5,
      unit_sale_price: 0
    )
    assert_not sale_item.valid?
    assert sale_item.errors[:unit_sale_price].any?
  end

  test "belongs to sale" do
    sale_item = sale_items(:beer_sale_item)
    assert_equal sales(:first_sale), sale_item.sale
  end

  test "belongs to stock_item" do
    sale_item = sale_items(:beer_sale_item)
    assert_equal stock_items(:beer_stock), sale_item.stock_item
  end
end
