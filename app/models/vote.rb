class Vote < ApplicationRecord
  belongs_to :post
  belongs_to :user

  def is_upvote?
    value >= 1
  end

  def is_downvote?
    value <= -1
  end

  def self.upvote(user, post)
    Vote.new(user: user, post: post, value: 1)
  end

  def self.downvote(user, post)
    Vote.new(user: user, post: post, value: -1)
  end
end
