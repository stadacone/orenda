# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  before_action :require_login

  def require_login
    unless user_signed_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to sign_up_url # halts request cycle
    end
  end
end
