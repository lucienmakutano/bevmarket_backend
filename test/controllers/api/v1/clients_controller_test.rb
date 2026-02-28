require "test_helper"

class Api::V1::ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user)
    sign_in @user
  end

  test "index returns clients for current establishment" do
    get api_v1_clients_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert json["data"]["clients"].is_a?(Array)
  end

  test "show returns a client" do
    client = clients(:regular_client)
    get api_v1_client_url(client)
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert_equal client.name, json["data"]["client"]["name"]
  end

  test "show returns not found for invalid id" do
    get api_v1_client_url(id: 999999)
    assert_response :not_found
    json = JSON.parse(response.body)
    assert_equal "fail", json["status"]
  end

  test "create creates a client" do
    assert_difference("Client.count", 1) do
      post api_v1_clients_url, params: {
        client: { name: "New Client", phone_number: "5551234567" }
      }
    end
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert_equal "New Client", json["data"]["client"]["name"]
    assert_equal @user.current_establishment_id, json["data"]["client"]["establishment_id"]
  end

  test "create fails without name" do
    assert_no_difference("Client.count") do
      post api_v1_clients_url, params: {
        client: { phone_number: "5559999999" }
      }
    end
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal "fail", json["status"]
  end

  test "update updates a client" do
    client = clients(:regular_client)
    patch api_v1_client_url(client), params: {
      client: { name: "Updated Name" }
    }
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "Updated Name", json["data"]["client"]["name"]
  end

  test "destroy deletes a client" do
    client = clients(:regular_client)
    assert_difference("Client.count", -1) do
      delete api_v1_client_url(client)
    end
  end

  test "unauthenticated request is rejected" do
    sign_out @user
    get api_v1_clients_url
    assert_response :unauthorized
  end
end
