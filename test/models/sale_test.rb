require "test_helper"

class SaleTest < ActiveSupport::TestCase
  test "valid sale from fixture" do
    sale = sales(:first_sale)
    assert sale.valid?
  end

  test "belongs to user" do
    sale = sales(:first_sale)
    assert_equal users(:admin_user), sale.user
  end

  test "belongs to client" do
    sale = sales(:first_sale)
    assert_equal clients(:regular_client), sale.client
  end

  test "belongs to sale_point" do
    sale = sales(:first_sale)
    assert_equal sale_points(:warehouse_point), sale.sale_point
  end

  test "belongs to establishment" do
    sale = sales(:first_sale)
    assert_equal establishments(:bevmart), sale.establishment
  end

  test "has many sale_items" do
    sale = sales(:first_sale)
    assert_includes sale.sale_items, sale_items(:beer_sale_item)
  end
end
