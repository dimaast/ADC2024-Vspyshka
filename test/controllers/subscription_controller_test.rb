require "test_helper"

class SubscriptionControllerTest < ActionDispatch::IntegrationTest
  test "should get toggle" do
    get subscription_toggle_url
    assert_response :success
  end
end
