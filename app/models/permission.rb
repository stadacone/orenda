# frozen_string_literal: true

class Permission < ApplicationRecord
  has_and_belongs_to_many :users

  def self.parse(value)
    parts = value.split(":")
    unless parts.count == 2
      raise
    end
    # Check permission can exist (find corresponding controller and action)
    if Permission.find_by(resource: parts[0], action: parts[1]).present?

    end
  end
end