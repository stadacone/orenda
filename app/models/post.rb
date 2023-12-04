# frozen_string_literal: true

class Post < ApplicationRecord
  before_save :get_post_metadata
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  kredis_counter :votes_tally

  validates :link, format: { with: URI::DEFAULT_PARSER.make_regexp }

  def upvote(user)
    votes.new(post: self, user: user, value: 1)
    votes_tally.increment
  end

  def downvote(user)
    votes.new(post: self, user: user, value: -1)
    votes_tally.decrement
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
