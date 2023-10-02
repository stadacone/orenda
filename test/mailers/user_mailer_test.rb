# frozen_string_literal: true
require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "confirmation" do
    thomas = users(:thomas)
    mail = UserMailer.confirmation thomas, thomas.generate_confirmation_token
    assert_equal "Confirmation Instructions", mail.subject
    assert_equal [thomas.email], mail.to
    assert_equal [User::MAILER_FROM_EMAIL], mail.from
    assert_select_email do
      assert_select "h1", "Confirmation Instructions"
    end
  end

end
