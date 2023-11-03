# frozen_string_literal: true

require "test_helper"

class ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  test "confirming with a valid token redirects to root page" do
    user = users(:tristan)
    confirmation_token = user.generate_confirmation_token

    get edit_confirmation_url(confirmation_token)
    user.reload

    assert_redirected_to root_url
    assert_equal true, user.confirmed?
  end

  test "confirming with an expired token redirects to new confirmation page" do
    user = users(:tristan)
    confirmation_token = user.generate_confirmation_token
    travel 11.minutes

    get edit_confirmation_url(confirmation_token)
    user.reload

    assert_redirected_to new_confirmation_url
    assert_equal false, user.confirmed?
  end

  test "confirming a confirmed user redirects to new confirmation page" do
    user = users(:tristan)
    confirmation_token = user.generate_confirmation_token

    get edit_confirmation_url(confirmation_token)
    user.reload

    assert_redirected_to root_url
    assert_equal true, user.confirmed?

    confirmation_token = user.generate_confirmation_token
    get edit_confirmation_url(confirmation_token)

    assert_redirected_to new_confirmation_path
  end
end
