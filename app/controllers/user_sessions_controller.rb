class UserSessionsController < ApplicationController
	before_filter :require_no_user, :only => [:new, :create]
	before_filter :require_user, :only => :destroy

	def new
    	@user_session = UserSession.new
	end

	def session_create
		email = session[:email]
		unless User.exists?(:email => email)
			@new_user = User.new(:email => email)
			@new_user.save
		end
	
    	unless UserSession.exists?(:email => :email)
    		@new_session = User.new(:email => email)
    		@new_session.save
		end
		
	  	flash[:invite] = "yes"
		redirect_to root_url
  	end

  	def destroy
    	current_user_session.destroy
    	flash[:notice] = "Logout successful!"
    	redirect_to root_url
  	end
end
