class Inviter < ActionMailer::Base
  default :from => "from@example.com",
  		  :return_path => "return@path.com"
  		  
	def invite(recipient)
		
		mail(:to => recipient,
		     :from => "return@path.com",
		     :subject => "Invitation to FishBowling")

	end
    
end
