class YahooController < ApplicationController

	def index
    @request_token = yahoo_oauth_consumer.get_request_token(:oauth_callback => "http://localhost.com/yahoo/yahoo_callback")
		session[:request_token] = @request_token.token
		session[:request_token_secret] = @request_token.secret
		puts @request_token.inspect
		redirect_to @request_token.authorize_url
	end

  def yahoo_oauth_consumer
    OAuth::Consumer.new('dj0yJmk9VzVNTWFTRURobFBuJmQ9WVdrOWRuUkxTV05WTXpRbWNHbzlNVEV4T1RVeU5UTTJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD03Nw--','1951179f6a893ed8d83fcd139264a045d0054d75', {
          :site                 => 'https://api.login.yahoo.com',
          :scheme               => :header,
          :request_token_path   => '/oauth/v2/get_request_token',
          :access_token_path    => '/oauth/v2/get_token',
          :authorize_path       => '/oauth/v2/request_auth'
        })
  end

  def yahoo_calendar_consumer
    OAuth::Consumer.new('dj0yJmk9VzVNTWFTRURobFBuJmQ9WVdrOWRuUkxTV05WTXpRbWNHbzlNVEV4T1RVeU5UTTJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD03Nw--','1951179f6a893ed8d83fcd139264a045d0054d75',
        {
          :site => 'http://social.yahooapis.com'
        })
  end

  def yahoo_callback
    if(params[:oauth_token] && params[:oauth_verifier])
			puts session.inspect + "-----------------"
      @request_token = OAuth::RequestToken.new(yahoo_oauth_consumer, session[:request_token], session[:request_token_secret])
      access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

      access_token.consumer = yahoo_calendar_consumer
      yahoo_guid = access_token.params[:xoauth_yahoo_guid]

	  puts response = access_token.get("/v1/public/yql?q=select%20*%20from%20social.profile%20where%20guid%3Dme&format=json")

      response = access_token.get("/v1/user/#{yahoo_guid}/contacts?format=json&count=max")
      json = ActiveSupport::JSON.decode(response.body)

			detail = access_token.get('/v1/user/4SMB3FTWDB675KQ2RV7ZYS5EWQ/contact/6?format=json')
			detail = ActiveSupport::JSON.decode(detail.body)	
#			render :json => detail
      @name_email_map = parse_yahoo_contacts_response(json)
#			render :json => @name_email_map.to_json]

	  @user_email = "saad@email.com"
	  
	  @user = User.find_by_email(@user_email)
	  if @user.blank?
	  	@user = User.create(:email => @user_email)
		save_contacts
	    flash[:invite] = "yes"
	  end
	  UserSession.create(@user)

	  redirect_to root_url
    end
  end

  def parse_yahoo_contacts_response(json)
    name_email_map = {}

    return name_email_map if json['contacts']['contact'].nil?

    json['contacts']['contact'].each do |contact|

      name = nil
      email = nil
			

      contact['fields'].each do |field|
        field['type']

        if field['type'] == 'name'
          name = "#{field['value']['givenName']} #{field['value']['familyName']}"
        end 

        if field['type'] == 'email'
          email = field['value']
        end

        if field['type'] == 'yahooid'
          email = field['value']+"@yahoo.com"
        end

      end

      if(email)
        name ||= email
        name_email_map[name] = email
      end
    end

    name_email_map
  end
  
  def getContacts()
  	@name_email_map = {}
    @contacts_obj_list = current_user.contacts
    
    @contacts_obj_list.each do |c|
    	@name_email_map[c.name] = c.email
    end
  	
  	render :json => @name_email_map.to_json
  end
  
  def save_contacts
  	@name_email_map.each_key do |c|
  		@user.contacts.create(:name => c, :email => @name_email_map[c])
  	end
  end

end
