require "application_system_test_case"

class HomepageTest < ApplicationSystemTestCase
  test "displays all games as links" do
    visit root_path

    Game.all.each do |game|
      assert_selector "a", text: game.title
    end
  end
end
