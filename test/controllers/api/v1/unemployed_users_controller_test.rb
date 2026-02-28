require "test_helper"

class Api::V1::UnemployedUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user)
    sign_in @user
  end

  test "index returns unemployed users" do
    get api_v1_unemployed_users_url
    assert_response :success
  end
end
