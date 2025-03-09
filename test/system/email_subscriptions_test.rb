require "application_system_test_case"

class EmailSubscriptionsTest < ApplicationSystemTestCase
  setup do
    @email_subscription = email_subscriptions(:one)
  end

  test "visiting the index" do
    visit email_subscriptions_url
    assert_selector "h1", text: "Email subscriptions"
  end

  test "should create email subscription" do
    visit email_subscriptions_url
    click_on "New email subscription"

    fill_in "Email", with: @email_subscription.email
    click_on "Create Email subscription"

    assert_text "Email subscription was successfully created"
    click_on "Back"
  end

  test "should update Email subscription" do
    visit email_subscription_url(@email_subscription)
    click_on "Edit this email subscription", match: :first

    fill_in "Email", with: @email_subscription.email
    click_on "Update Email subscription"

    assert_text "Email subscription was successfully updated"
    click_on "Back"
  end

  test "should destroy Email subscription" do
    visit email_subscription_url(@email_subscription)
    click_on "Destroy this email subscription", match: :first

    assert_text "Email subscription was successfully destroyed"
  end
end
