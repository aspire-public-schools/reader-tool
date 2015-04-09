class UserMailer < ActionMailer::Base
  default from: "do-not-reply@example.com"

  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => "Password Reset"
  end
end
