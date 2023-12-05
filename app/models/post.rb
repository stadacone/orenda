# frozen_string_literal: true

class Post < ApplicationRecord
  before_save :get_post_metadata
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  kredis_counter :votes_tally

  validates :link, format: { with: URI::DEFAULT_PARSER.make_regexp }

  def upvote(user)
    if downvoted_by? user
      vote = Vote.find_by(user: user, post: self)
      vote.destroy!
    end
    votes.new(post: self, user: user, value: 1)
  end

  def downvote(user)
    if upvoted_by? user
      vote = Vote.find_by(user: user, post: self)
      vote.destroy!
    end
    votes.new(post: self, user: user, value: -1)
  end

  def unvote(user)
    Vote.find_by(user: user, post: self)&.destroy!
  end

  def upvoted_by?(user)
    vote = Vote.find_by(user: user, post: self)
    vote.present? && vote.is_upvote?
  end

  def downvoted_by?(user)
    vote = Vote.find_by(user: user, post: self)
    vote.present? && vote.is_downvote?
  end

  def tally(vote)
    if vote.is_upvote?
      votes_tally.increment
    elsif vote.is_downvote?
      votes_tally.decrement
    end
  end

  def untally(vote)
    if vote.is_upvote?
      votes_tally.decrement
    elsif vote.is_downvote?
      votes_tally.increment
    end
  end

  private

  def get_post_metadata
    page = MetaInspector.new(link)
    self.description = page.best_description
    self.image_source = page.images.best
  rescue
    self.description = nil
    self.image_source = nil
  end
end
