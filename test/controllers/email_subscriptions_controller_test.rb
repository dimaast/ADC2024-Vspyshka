require "test_helper"

class EmailSubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @email_subscription = email_subscriptions(:one)
  end

  test "should get index" do
    get email_subscriptions_url
    assert_response :success
  end

  test "should get new" do
    get new_email_subscription_url
    assert_response :success
  end

  test "should create email_subscription" do
    assert_difference("EmailSubscription.count") do
      post email_subscriptions_url, params: { email_subscription: { email: @email_subscription.email } }
    end

    assert_redirected_to email_subscription_url(EmailSubscription.last)
  end

  test "should show email_subscription" do
    get email_subscription_url(@email_subscription)
    assert_response :success
  end

  test "should get edit" do
    get edit_email_subscription_url(@email_subscription)
    assert_response :success
  end

  test "should update email_subscription" do
    patch email_subscription_url(@email_subscription), params: { email_subscription: { email: @email_subscription.email } }
    assert_redirected_to email_subscription_url(@email_subscription)
  end

  test "should destroy email_subscription" do
    assert_difference("EmailSubscription.count", -1) do
      delete email_subscription_url(@email_subscription)
    end

    assert_redirected_to email_subscriptions_url
  end
end
