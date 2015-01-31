module SessionHelper

	def logout
		session.clear
	end

	def current_user
	 Reader.find(session[:current_reader_id]) if signed_in?
	end

	def signed_in?
		session[:current_reader_id] ? true : false
	end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def require_login
    redirect_to login_path unless signed_in?
  end

end
