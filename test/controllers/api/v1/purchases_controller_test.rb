require "test_helper"

class Api::V1::PurchasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user)
    sign_in @user
  end

  test "index returns purchases for a client" do
    get api_v1_purchases_url, params: { client_id: clients(:regular_client).id }
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert json["data"]["purchases"].is_a?(Array)
  end
end
