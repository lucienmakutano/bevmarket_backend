require "test_helper"

class ItemTest < ActiveSupport::TestCase
  test "valid item from fixture" do
    item = items(:beer_item)
    assert item.valid?
  end

  test "requires name" do
    item = Item.new(bottles_number: 24, capacity: 50, establishment: establishments(:bevmart))
    assert_not item.valid?
    assert_includes item.errors[:name], "can't be blank"
  end

  test "requires bottles_number" do
    item = Item.new(name: "Test", capacity: 50, establishment: establishments(:bevmart))
    assert_not item.valid?
    assert_includes item.errors[:bottles_number], "can't be blank"
  end

  test "requires capacity" do
    item = Item.new(name: "Test", bottles_number: 24, establishment: establishments(:bevmart))
    assert_not item.valid?
    assert_includes item.errors[:capacity], "can't be blank"
  end

  test "belongs to establishment" do
    item = items(:beer_item)
    assert_equal establishments(:bevmart), item.establishment
  end

  test "has many stock_items" do
    item = items(:beer_item)
    assert_includes item.stock_item, stock_items(:beer_stock)
  end
end
