class Vote < ApplicationRecord
  before_save :update_post_tally

  belongs_to :post
  belongs_to :user

  private

  def update_post_tally
    post.votes_tally += value
  end
end
