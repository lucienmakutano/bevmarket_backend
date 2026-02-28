require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user)
    sign_in @user
  end

  test "index returns unemployed users" do
    get api_v1_users_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    emails = json["data"]["unemployed_users"].map { |u| u["email"] }
    assert_includes emails, users(:unemployed_user).email
  end

  test "show returns a user with employee data when employed" do
    get api_v1_user_url(users(:admin_user))
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert json["data"]["user"].present?
    assert json["data"]["employee"].present?
  end

  test "show returns a user without employee when not employed" do
    get api_v1_user_url(users(:unemployed_user))
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert json["data"]["user"].present?
    assert_nil json["data"]["employee"]
  end

  test "show returns not found for invalid id" do
    get api_v1_user_url(id: 999999)
    assert_response :not_found
  end

  test "update updates user" do
    patch api_v1_user_url(users(:unemployed_user)), params: {
      user: { name: "Updated Name" }
    }
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "Updated Name", json["data"]["user"]["name"]
  end
end
