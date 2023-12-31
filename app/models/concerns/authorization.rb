# frozen_string_literal: true

module Authorization
  extend ActiveSupport::Concern

  included do
    before_action :verify_permissions
  end

  def verify_permissions
    permission = Permission.find_by(resource: controller_name, action: action_name)
    unless permission.in? current_user&.permissions
      flash[:error] = "You don't have permission to perform this action on this resource."
      redirect_to root_url, status: :forbidden
    end
  end
end
