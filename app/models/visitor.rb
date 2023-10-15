# frozen_string_literal: true

class Visitor
  def permissions
    %w[posts:index posts:show users:new users:create sessions:new sessions:create]
  end
end
