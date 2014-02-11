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
end
