# frozen_string_literal: true

class Post < ApplicationRecord
  before_save :get_post_metadata
  belongs_to :user

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
