# frozen_string_literal: true

class Post < ApplicationRecord
  before_save :get_post_description
  after_initialize :get_post_image
  attr_accessor :image

  def get_post_description
    page = MetaInspector.new(self.link)
    self.description = page.best_description
  end

  def get_post_image
    begin
      page = MetaInspector.new(self.link)
      self.image = page.images.best
    rescue
      self.image = nil
    end
  end
end
