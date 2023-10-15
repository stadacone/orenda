# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user

  validates :link, format: {with: URI::DEFAULT_PARSER.make_regexp}
end
