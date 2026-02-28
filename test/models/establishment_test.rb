require "test_helper"

class EstablishmentTest < ActiveSupport::TestCase
  test "valid establishment from fixture" do
    establishment = establishments(:bevmart)
    assert establishment.valid?
  end

  test "requires name" do
    establishment = Establishment.new(created_by: users(:admin_user).id)
    assert_not establishment.valid?
    assert_includes establishment.errors[:name], "can't be blank"
  end

  test "has many employees" do
    establishment = establishments(:bevmart)
    assert_includes establishment.employees, employees(:admin_employee)
  end

  test "has many sale_points" do
    establishment = establishments(:bevmart)
    assert_includes establishment.sale_points, sale_points(:warehouse_point)
  end

  test "has many items" do
    establishment = establishments(:bevmart)
    assert_includes establishment.items, items(:beer_item)
  end

  test "has many clients" do
    establishment = establishments(:bevmart)
    assert_includes establishment.clients, clients(:regular_client)
  end

  test "has many expenses" do
    establishment = establishments(:bevmart)
    assert_includes establishment.expenses, expenses(:office_expense)
  end

  test "has many sales" do
    establishment = establishments(:bevmart)
    assert_includes establishment.sales, sales(:first_sale)
  end

  test "belongs to user via created_by" do
    establishment = establishments(:bevmart)
    assert_equal users(:admin_user), establishment.user
  end
end
