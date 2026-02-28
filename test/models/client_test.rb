require "test_helper"

class ClientTest < ActiveSupport::TestCase
  test "valid client from fixture" do
    client = clients(:regular_client)
    assert client.valid?
  end

  test "requires name" do
    client = Client.new(phone_number: "5555555555", establishment: establishments(:bevmart))
    assert_not client.valid?
    assert_includes client.errors[:name], "can't be blank"
  end

  test "requires phone_number" do
    client = Client.new(name: "Test", establishment: establishments(:bevmart))
    assert_not client.valid?
    assert_includes client.errors[:phone_number], "can't be blank"
  end

  test "belongs to establishment" do
    client = clients(:regular_client)
    assert_equal establishments(:bevmart), client.establishment
  end

  test "has many sales" do
    client = clients(:regular_client)
    assert_includes client.sales, sales(:first_sale)
  end

  test "partner client has credit" do
    client = clients(:partner_client)
    assert_equal 100.0, client.credit
    assert client.is_partener
  end

  test "default credit is zero" do
    client = Client.create!(name: "Zero Credit", phone_number: "1112223333", establishment: establishments(:bevmart))
    assert_equal 0.0, client.credit
  end
end
