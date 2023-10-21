# frozen_string_literal: true

class Permission < ApplicationRecord
  has_and_belongs_to_many :users
end

class PermissionType < ActiveRecord::Type::Text
  def cast(value)
    parts = value.split(":")
    unless parts.count == 2
      super
    end
    # Check permission can exist (find corresponding controller and action)
    Permission.new(resource: parts[0], action: parts[1])
  end
end