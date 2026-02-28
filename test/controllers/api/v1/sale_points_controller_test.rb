require "test_helper"

class Api::V1::SalePointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user)
    sign_in @user
  end

  test "index returns sale points for current establishment" do
    get api_v1_sale_points_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert json["data"]["sale_points"].is_a?(Array)
  end

  test "show returns a sale point with truck or warehouse" do
    sale_point = sale_points(:warehouse_point)
    get api_v1_sale_point_url(sale_point)
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert json["data"]["sale_point"]["warehouse"].present?
  end
end
