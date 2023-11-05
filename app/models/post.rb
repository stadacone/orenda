# frozen_string_literal: true

class Post < ApplicationRecord
  before_save :get_post_metadata
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  kredis_integer :votes_tally, default: 0

  validates :link, format: { with: URI::DEFAULT_PARSER.make_regexp }

  def get_post_metadata
    page = MetaInspector.new(link)
    self.description = page.best_description
    self.image_source = page.images.best
  rescue
    self.description = nil
    self.image_source = nil
  end
end
