require "test_helper"

class Api::V1::SalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user)
    sign_in @user
  end

  test "show returns a sale" do
    sale = sales(:first_sale)
    get api_v1_sale_url(sale)
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
  end

  test "show returns not found for invalid id" do
    get api_v1_sale_url(id: 999999)
    assert_response :not_found
    json = JSON.parse(response.body)
    assert_equal "fail", json["status"]
  end

  test "create creates a sale and deducts stock" do
    stock_item = stock_items(:beer_stock)
    original_quantity = stock_item.quantity
    sale_quantity = 5

    assert_difference("Sale.count", 1) do
      assert_difference("SaleItem.count", 1) do
        post api_v1_sales_url, params: {
          sale: {
            user_id: @user.id,
            client_id: clients(:regular_client).id,
            sale_point_id: sale_points(:warehouse_point).id,
            credit: 0,
            sale_items: [
              {
                stock_item_id: stock_item.id,
                quantity: sale_quantity,
                unit_sale_price: 600
              }
            ]
          }
        }, as: :json
      end
    end
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]

    stock_item.reload
    assert_equal original_quantity - sale_quantity, stock_item.quantity
  end

  test "create fails when stock is insufficient" do
    stock_item = stock_items(:beer_stock)

    assert_no_difference("Sale.count") do
      post api_v1_sales_url, params: {
        sale: {
          user_id: @user.id,
          client_id: clients(:regular_client).id,
          sale_point_id: sale_points(:warehouse_point).id,
          credit: 0,
          sale_items: [
            {
              stock_item_id: stock_item.id,
              quantity: 99999,
              unit_sale_price: 600
            }
          ]
        }
      }, as: :json
    end
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal "fail", json["status"]
    assert_match(/not enough/i, json["error"]["message"])
  end

  test "create updates client credit" do
    client = clients(:regular_client)
    original_credit = client.credit
    credit_amount = 50.0

    post api_v1_sales_url, params: {
      sale: {
        user_id: @user.id,
        client_id: client.id,
        sale_point_id: sale_points(:warehouse_point).id,
        credit: credit_amount,
        sale_items: [
          {
            stock_item_id: stock_items(:beer_stock).id,
            quantity: 2,
            unit_sale_price: 600
          }
        ]
      }
    }, as: :json
    assert_response :created
    client.reload
    assert_equal original_credit + credit_amount, client.credit
  end
end
