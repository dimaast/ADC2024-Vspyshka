require "test_helper"

class ResponseControllerTest < ActionDispatch::IntegrationTest
  test "should get toggle" do
    get response_toggle_url
    assert_response :success
  end
end
