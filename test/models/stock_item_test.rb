require "test_helper"

class StockItemTest < ActiveSupport::TestCase
  test "valid stock_item from fixture" do
    stock_item = stock_items(:beer_stock)
    assert stock_item.valid?
  end

  test "requires quantity" do
    stock_item = StockItem.new(
      item: items(:beer_item),
      unit_sale_price: 600,
      last_unit_buy_price: 500,
      reduction_sale_price: 550,
      average_unit_buy_price: 500
    )
    assert_not stock_item.valid?
    assert_includes stock_item.errors[:quantity], "can't be blank"
  end

  test "requires unit_sale_price" do
    stock_item = StockItem.new(
      item: items(:beer_item),
      quantity: 100,
      last_unit_buy_price: 500,
      reduction_sale_price: 550,
      average_unit_buy_price: 500
    )
    assert_not stock_item.valid?
    assert_includes stock_item.errors[:unit_sale_price], "can't be blank"
  end

  test "requires last_unit_buy_price" do
    stock_item = StockItem.new(
      item: items(:beer_item),
      quantity: 100,
      unit_sale_price: 600,
      reduction_sale_price: 550,
      average_unit_buy_price: 500
    )
    assert_not stock_item.valid?
    assert_includes stock_item.errors[:last_unit_buy_price], "can't be blank"
  end

  test "requires reduction_sale_price" do
    stock_item = StockItem.new(
      item: items(:beer_item),
      quantity: 100,
      unit_sale_price: 600,
      last_unit_buy_price: 500,
      average_unit_buy_price: 500
    )
    assert_not stock_item.valid?
    assert_includes stock_item.errors[:reduction_sale_price], "can't be blank"
  end

  test "requires average_unit_buy_price" do
    stock_item = StockItem.new(
      item: items(:beer_item),
      quantity: 100,
      unit_sale_price: 600,
      last_unit_buy_price: 500,
      reduction_sale_price: 550
    )
    assert_not stock_item.valid?
    assert_includes stock_item.errors[:average_unit_buy_price], "can't be blank"
  end

  test "belongs to item" do
    stock_item = stock_items(:beer_stock)
    assert_equal items(:beer_item), stock_item.item
  end

  test "has many sale_items" do
    stock_item = stock_items(:beer_stock)
    assert_includes stock_item.sale_items, sale_items(:beer_sale_item)
  end
end
