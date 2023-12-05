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
    post.tally self
  end

  def untally
    post.untally self
  end
end
