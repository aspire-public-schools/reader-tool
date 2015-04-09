class AdminController < ApplicationController
  before_filter :require_admin

  private

  def require_admin
    redirect_to root_path, flash: {error: "Not authorized for admin access!"} unless current_user.reader2?
  end

end

