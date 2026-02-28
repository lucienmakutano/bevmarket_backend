require "test_helper"

class Api::V1::ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user)
    sign_in @user
  end

  test "show returns an item" do
    item = items(:beer_item)
    get api_v1_item_url(item)
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert_equal item.name, json["data"]["item"]["name"]
  end

  test "show returns not found for invalid id" do
    get api_v1_item_url(id: 999999)
    assert_response :not_found
  end

  test "create creates item with stock_item and stock_movement" do
    assert_difference("Item.count", 1) do
      assert_difference("StockItem.count", 1) do
        assert_difference("StockMovement.count", 1) do
          post api_v1_items_url, params: {
            item: { name: "New Drink", bottles_number: 6, capacity: 33, capacity_unit: "cl" },
            stock_item: {
              quantity: 50,
              unit_sale_price: 800,
              last_unit_buy_price: 600,
              reduction_sale_price: 700,
              average_unit_buy_price: 600
            }
          }
        end
      end
    end
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert_equal "New Drink", json["data"]["item"]["name"]
  end

  test "create fails without required item fields" do
    assert_no_difference("Item.count") do
      post api_v1_items_url, params: {
        item: { name: "" },
        stock_item: {
          quantity: 50,
          unit_sale_price: 800,
          last_unit_buy_price: 600,
          reduction_sale_price: 700,
          average_unit_buy_price: 600
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "update updates an item" do
    item = items(:beer_item)
    patch api_v1_item_url(item), params: {
      item: { name: "Updated Beer" }
    }
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "Updated Beer", json["data"]["item"]["name"]
  end

  test "destroy deletes an item" do
    item = items(:beer_item)
    assert_difference("Item.count", -1) do
      delete api_v1_item_url(item)
    end
  end
end
