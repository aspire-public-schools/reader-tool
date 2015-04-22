require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do
  describe "password_reset" do
    let(:user) { create(:reader) }
    let(:mail) { UserMailer.password_reset(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Password Reset")
      expect(mail.to).to eq([user.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("reset your password")
    end
  end

end
