require "test_helper"

class StockMovementTest < ActiveSupport::TestCase
  test "valid stock_movement from fixture" do
    movement = stock_movements(:beer_purchase)
    assert movement.valid?
  end

  test "requires quantity" do
    movement = StockMovement.new(
      stock_item: stock_items(:beer_stock),
      movement_type: "purchase",
      unit_price: 500,
      establishment: establishments(:bevmart)
    )
    assert_not movement.valid?
    assert_includes movement.errors[:quantity], "can't be blank"
  end

  test "requires movement_type" do
    movement = StockMovement.new(
      stock_item: stock_items(:beer_stock),
      quantity: 10,
      unit_price: 500,
      establishment: establishments(:bevmart)
    )
    assert_not movement.valid?
    assert_includes movement.errors[:movement_type], "can't be blank"
  end

  test "requires unit_price" do
    movement = StockMovement.new(
      stock_item: stock_items(:beer_stock),
      quantity: 10,
      movement_type: "purchase",
      establishment: establishments(:bevmart)
    )
    assert_not movement.valid?
    assert_includes movement.errors[:unit_price], "can't be blank"
  end

  test "belongs to stock_item" do
    movement = stock_movements(:beer_purchase)
    assert_equal stock_items(:beer_stock), movement.stock_item
  end

  test "belongs to establishment" do
    movement = stock_movements(:beer_purchase)
    assert_equal establishments(:bevmart), movement.establishment
  end

  test "purchase movement type" do
    movement = stock_movements(:beer_purchase)
    assert_equal "purchase", movement.movement_type
  end
end
