class PasswordResetsController < ApplicationController
  skip_before_filter :require_login

  # taken from http://railscasts.com/episodes/274-remember-me-reset-password?view=asciicast

  def create
    if user = Reader.find_by_email(params[:email])
      user.send_password_reset
      flash[:notice] = "Email sent to #{params[:email]} with password reset instructions." 
    else
      flash[:error]  = "That user was not found, or the email could not be sent."
    end
    redirect_to return_to_location || root_url, flash
  end

  def edit
    @user = Reader.find_by_password_reset_token!(params[:id])
  end

  def update
    logout
    @user = Reader.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    elsif @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Password has been reset."
    else
      render :edit
    end
  end

end
