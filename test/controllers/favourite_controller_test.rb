require "test_helper"

class FavouriteControllerTest < ActionDispatch::IntegrationTest
  test "should get toggle" do
    get favourite_toggle_url
    assert_response :success
  end
end
