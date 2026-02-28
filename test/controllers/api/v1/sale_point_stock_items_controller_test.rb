require "test_helper"

class Api::V1::SalePointStockItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user)
    sign_in @user
  end

  test "create creates a sale point stock item" do
    assert_difference("SalePointStockItem.count", 1) do
      post api_v1_sale_point_stock_items_url, params: {
        sale_point_stock_item: {
          stock_item_id: stock_items(:soda_stock).id,
          sale_point_id: sale_points(:warehouse_point).id,
          quantity: 30
        }
      }, as: :json
    end
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
  end
end
