class PhotosController < ApplicationController

	before_filter :require_user, :only => :create

	def create
		File.open(upload_path, 'w') do |f|
      f.write request.raw_post.force_encoding("UTF-8")
    end
		@photo = Photo.create( params[:photo] )
#		tt = File.join(RAILS_ROOT, 'public', 'uploads', "waj.jpg")
		@photo.picture = File.new(upload_path)
		
		@photo.save

		redirect_to root_url
	end

	def index
		paths = []
		Photo.find(:all).each do |photo|
			paths << photo.picture.url
		end

		render :json => { :files => paths }.to_json
	end

	private

  def upload_path # is used in upload and create
    file_name = session[:session_id].to_s + '.jpg'
    File.join(RAILS_ROOT, 'public', 'uploads', file_name)
  end


end
