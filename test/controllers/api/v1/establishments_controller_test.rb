require "test_helper"

class Api::V1::EstablishmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user)
    sign_in @user
  end

  test "index returns all establishments" do
    get api_v1_establishments_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert json["data"]["establishments"].is_a?(Array)
  end

  test "create creates establishment with sale_point, warehouse, and employee" do
    new_user = User.create!(name: "Owner", email: "owner@example.com", password: "password123")

    assert_difference ["Establishment.count", "SalePoint.count", "Warehouse.count", "Employee.count"], 1 do
      post api_v1_establishments_url, params: {
        establishment: { name: "New Distro", created_by: new_user.id },
        warehouse: { name: "HQ Warehouse", location: "City Center" }
      }, as: :json
    end
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]

    new_user.reload
    assert new_user.is_employed
  end
end
