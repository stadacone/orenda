# frozen_string_literal: true

class Visitor
  def permissions
    [
      Permission.find_or_create_by(resource: "posts", action: "index"),
      Permission.find_or_create_by(resource: "posts", action: "show"),
      Permission.find_or_create_by(resource: "users", action: "new"),
      Permission.find_or_create_by(resource: "users", action: "create"),
      Permission.find_or_create_by(resource: "sessions", action: "new"),
      Permission.find_or_create_by(resource: "sessions", action: "create")
    ]
  end
end
