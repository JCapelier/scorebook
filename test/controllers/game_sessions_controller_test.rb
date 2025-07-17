require "test_helper"

class GameSessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get game_sessions_new_url
    assert_response :success
  end

  test "should get create" do
    get game_sessions_create_url
    assert_response :success
  end
end
