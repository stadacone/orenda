class Vote < ApplicationRecord
  belongs_to :post
  belongs_to :user
  after_create :tally
  before_destroy :untally

  def is_upvote?
    value >= 1
  end

  def is_downvote?
    value <= -1
  end

  private

  def tally
    if is_upvote?
      post.votes_tally.increment
    elsif is_downvote?
      post.votes_tally.decrement
    end
  end

  def untally
    if is_upvote?
      post.votes_tally.decrement
    elsif is_downvote?
      post.votes_tally.increment
    end
  end
end
