module ApplicationHelper
	def onLoad
		if flash[:invite] == "yes"
			return "onload='$(\"a.invitebox\").trigger(\"click\");'"
		end
		
		if session[:popup] == "no"
			return " "
		else
			session[:popup]	= "no"
			$name_email_map = ""
			return "onload='$(\"a.loginbox\").trigger(\"click\");'"
		end
	end
end
