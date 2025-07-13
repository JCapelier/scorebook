require "test_helper"

class SessionPlayersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get session_players_new_url
    assert_response :success
  end

  test "should get create" do
    get session_players_create_url
    assert_response :success
  end
end
