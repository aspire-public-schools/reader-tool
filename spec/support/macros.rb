
def login user
  # let(:current_user) { user }
  allow(controller).to receive(:current_user).and_return(user)
  session[:current_reader_id] = user.id
end

def current_user
  controller.current_user
end

def logout
  allow(controller).to receive(:current_user).and_return(nil)
  session[:current_reader_id] = nil
end
