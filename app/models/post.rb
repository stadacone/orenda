# frozen_string_literal: true

class Post < ApplicationRecord
  before_save :get_link_description
  attr_accessor :image

  def get_link_description
    page = MetaInspector.new(self.link)
    self.description = page.best_description
  end
end
