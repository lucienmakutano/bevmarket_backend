require "test_helper"

class Api::V1::ExpensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user)
    sign_in @user
  end

  test "index returns expenses for a date" do
    expense = expenses(:office_expense)
    date = expense.created_at.to_date.iso8601
    get api_v1_expenses_url, params: { date: date }
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert json["data"]["expenses"].is_a?(Array)
  end

  test "index returns expenses for date range" do
    expense = expenses(:office_expense)
    from_date = (expense.created_at.to_date - 1.day).iso8601
    to_date = (expense.created_at.to_date + 1.day).iso8601
    get api_v1_expenses_url, params: { from: from_date, to: to_date }
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
  end

  test "index returns empty array without date params" do
    get api_v1_expenses_url
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal [], json["data"]["expenses"]
  end

  test "show returns an expense" do
    expense = expenses(:office_expense)
    get api_v1_expense_url(expense)
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert_equal expense.amount.to_f, json["data"]["expense"]["amount"].to_f
  end

  test "show returns not found for invalid id" do
    get api_v1_expense_url(id: 999999)
    assert_response :not_found
  end

  test "create creates an expense" do
    assert_difference("Expense.count", 1) do
      post api_v1_expenses_url, params: {
        expense: {
          amount: 1000,
          reason: "Transport",
          user_id: @user.id,
          sale_point_id: sale_points(:warehouse_point).id
        }
      }
    end
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "success", json["status"]
    assert_equal @user.current_establishment_id, json["data"]["expense"]["establishment_id"]
  end

  test "create fails without amount" do
    assert_no_difference("Expense.count") do
      post api_v1_expenses_url, params: {
        expense: {
          reason: "Test",
          user_id: @user.id,
          sale_point_id: sale_points(:warehouse_point).id
        }
      }
    end
    assert_response :unprocessable_entity
  end
end
