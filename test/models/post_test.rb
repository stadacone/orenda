# frozen_string_literal: true

require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "upvoting an unvoted post makes it upvoted by the user" do
    post = posts(:unvoted)
    user = users(:thomas)

    post.upvote(user)
    post.save

    assert post.upvoted_by? user
  end

  test "downvoting an unvoted post makes it downvoted by the user" do
    post = posts(:unvoted)
    user = users(:thomas)

    post.downvote(user)
    post.save

    assert post.downvoted_by? user
  end

  test "a post can be voted on by multiple users" do
    post = posts(:unvoted)
    first_user = users(:thomas)
    second_user = users(:tristan)

    post.downvote(first_user)
    post.downvote(second_user)
    post.save

    assert post.downvoted_by? first_user
    assert post.downvoted_by? second_user
    assert_equal post.votes_tally.value, -2
  end

  test "a user can unvote a post" do
    post = posts(:unvoted)
    user = users(:thomas)

    post.downvote user
    post.save
    post.unvote user
    post.save

    assert !post.downvoted_by?(user)
    assert_equal post.votes_tally.value, 0
  end
end
