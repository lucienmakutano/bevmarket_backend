require "test_helper"

class Api::V1::StockMovementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user)
    sign_in @user
  end

  test "index returns stock movements for a date" do
    movement = stock_movements(:beer_purchase)
    date = movement.created_at.to_date.iso8601
    get api_v1_stock_movements_url, params: { date: date }
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert json["data"]["stock_movements"].is_a?(Array)
  end

  test "index returns stock movements for date range" do
    movement = stock_movements(:beer_purchase)
    from_date = (movement.created_at.to_date - 1.day).iso8601
    to_date = (movement.created_at.to_date + 1.day).iso8601
    get api_v1_stock_movements_url, params: { from: from_date, to: to_date }
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
  end
end
