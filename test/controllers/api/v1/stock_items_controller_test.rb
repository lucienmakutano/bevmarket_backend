require "test_helper"

class Api::V1::StockItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user)
    sign_in @user
  end

  test "index returns stock items for current establishment" do
    get api_v1_stock_items_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert json["data"]["stock_items"].is_a?(Array)
  end

  test "show returns a stock item" do
    stock_item = stock_items(:beer_stock)
    get api_v1_stock_item_url(stock_item)
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
  end

  test "show returns not found for invalid id" do
    get api_v1_stock_item_url(id: 999999)
    assert_response :not_found
  end

  test "update with is_adding_to_stock mode adds quantity" do
    stock_item = stock_items(:beer_stock)
    original_quantity = stock_item.quantity
    add_quantity = 20

    patch api_v1_stock_item_url(stock_item), params: {
      update_mode: "is_adding_to_stock",
      stock_item: { quantity: add_quantity, unit_buy_price: 550 }
    }, as: :json
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]

    stock_item.reload
    assert_equal original_quantity + add_quantity, stock_item.quantity
  end

  test "update with is_adding_to_stock creates stock movement" do
    stock_item = stock_items(:beer_stock)
    assert_difference("StockMovement.count", 1) do
      patch api_v1_stock_item_url(stock_item), params: {
        update_mode: "is_adding_to_stock",
        stock_item: { quantity: 10, unit_buy_price: 500 }
      }, as: :json
    end
  end

  test "update with is_updating_price mode updates prices" do
    stock_item = stock_items(:beer_stock)
    patch api_v1_stock_item_url(stock_item), params: {
      update_mode: "is_updating_price",
      stock_item: { unit_sale_price: 700, reduction_sale_price: 650 }
    }, as: :json
    assert_response :success
    stock_item.reload
    assert_equal 700, stock_item.unit_sale_price
    assert_equal 650, stock_item.reduction_sale_price
  end

  test "update without mode returns error" do
    stock_item = stock_items(:beer_stock)
    patch api_v1_stock_item_url(stock_item), params: {
      stock_item: { quantity: 10 }
    }, as: :json
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_match(/update mode/i, json["error"]["message"])
  end
end
