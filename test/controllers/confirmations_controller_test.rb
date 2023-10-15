# frozen_string_literal: true

require "test_helper"

class ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  test "confirming with a valid token redirects to root page" do
    thomas = users(:thomas)
    confirmation_token = thomas.generate_confirmation_token

    get edit_confirmation_url(confirmation_token)
    thomas.reload

    assert_redirected_to root_url
    assert_equal true, thomas.confirmed?
  end

  test "confirming with an expired token redirects to new confirmation page" do
    thomas = users(:thomas)
    confirmation_token = thomas.generate_confirmation_token
    travel 11.minutes

    get edit_confirmation_url(confirmation_token)
    thomas.reload

    assert_redirected_to new_confirmation_url
    assert_equal false, thomas.confirmed?
  end

  test "confirming a confirmed user redirects to new confirmation page" do
    thomas = users(:thomas)
    confirmation_token = thomas.generate_confirmation_token

    get edit_confirmation_url(confirmation_token)
    thomas.reload

    assert_redirected_to root_url
    assert_equal true, thomas.confirmed?

    confirmation_token = thomas.generate_confirmation_token
    get edit_confirmation_url(confirmation_token)

    assert_redirected_to new_confirmation_path
  end
end
