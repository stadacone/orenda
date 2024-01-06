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
end
