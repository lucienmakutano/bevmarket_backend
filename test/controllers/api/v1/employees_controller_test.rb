require "test_helper"

class Api::V1::EmployeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user)
    sign_in @user
  end

  test "index returns employees for current establishment" do
    get api_v1_employees_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert json["data"]["employees"].is_a?(Array)
  end

  test "index returns current employee when given establishment_id and user_id" do
    get api_v1_employees_url, params: {
      establishment_id: establishments(:bevmart).id,
      user_id: @user.id
    }
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert json["data"]["current_employee"].present?
  end

  test "show returns an employee" do
    employee = employees(:admin_employee)
    get api_v1_employee_url(employee)
    assert_response :success
    json = JSON.parse(response.body)
    assert json["data"]["employee"].present?
  end

  test "show returns not found for invalid id" do
    get api_v1_employee_url(id: 999999)
    assert_response :not_found
  end

  test "create creates an employee" do
    unemployed = users(:unemployed_user)
    assert_difference("Employee.count", 1) do
      post api_v1_employees_url, params: {
        employee: {
          user_id: unemployed.id,
          role: "employee",
          sale_point_id: sale_points(:warehouse_point).id
        }
      }, as: :json
    end
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]

    unemployed.reload
    assert unemployed.is_employed
  end

  test "destroy removes employee and updates user" do
    employee = employees(:regular_employee)
    delete api_v1_employee_url(employee)
    assert_response :no_content

    users(:employee_user).reload
    assert_not users(:employee_user).is_employed
  end
end
