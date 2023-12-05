require "test_helper"

class VoteTest < ActiveSupport::TestCase
  test "an upvote is a vote with a positive value" do
    vote = Vote.new do |v|
      v.user = users(:thomas)
      v.post = posts(:one)
      v.value = 1
    end

    assert vote.is_upvote?
  end

  test "a downvote is a vote with a negative value" do
    vote = Vote.new do |v|
      v.user = users(:thomas)
      v.post = posts(:one)
      v.value = -1
    end

    assert vote.is_downvote?
  end

  test "a vote tallies itself on its post's tally upon creation" do
    post = posts(:unvoted)
    vote = Vote.create(post: post, user: users(:thomas), value: 1)

    assert_equal post.votes_tally.value, vote.value
  end

  test "a vote un-tallies itself on its post's tally upon destruction" do
    post = posts(:unvoted)
    vote = Vote.create(post: post, user: users(:thomas), value: -1)
    vote.destroy!

    assert_equal post.votes_tally.value, 0
  end
end
