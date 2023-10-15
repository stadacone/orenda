# frozen_string_literal: true

class Permission < ApplicationRecord
  has_and_belongs_to_many :users

  def to_str
    "#{:resource}:#{:action}"
  end
end
