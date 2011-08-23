class InviteController < ApplicationController

	def index
		params.each_key do |key|
			if params[key] == "Invite"
				break
			end
			Inviter.invite(params[key]).deliver
		end
		redirect_to root_url
	end
	
end
