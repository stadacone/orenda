# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  before_action :verify_permissions

  def verify_permissions
    unless "#{controller_name}:#{action_name}".in? current_user&.permissions
      flash[:error] = "You must be logged in to access this section"
      redirect_to root_url
    end
  end
end
