require "test_helper"

class RoundsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get rounds_create_url
    assert_response :success
  end

  test "should get update" do
    get rounds_update_url
    assert_response :success
  end
end
