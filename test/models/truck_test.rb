require "test_helper"

class TruckTest < ActiveSupport::TestCase
  test "valid truck from fixture" do
    truck = trucks(:delivery_truck)
    assert truck.valid?
  end

  test "requires marque" do
    truck = Truck.new(matricule: "XYZ-999", sale_point: sale_points(:truck_point))
    assert_not truck.valid?
    assert_includes truck.errors[:marque], "can't be blank"
  end

  test "belongs to sale_point" do
    truck = trucks(:delivery_truck)
    assert_equal sale_points(:truck_point), truck.sale_point
  end
end
