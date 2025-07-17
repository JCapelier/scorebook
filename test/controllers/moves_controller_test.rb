require "test_helper"

class MovesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get moves_create_url
    assert_response :success
  end
end
