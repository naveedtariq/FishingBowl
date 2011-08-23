class PhotosController < ApplicationController

	def create
		@photo = Photo.create( params[:photo] )
		redirect_to root_url
	end

	def index
		paths = []
		Photo.find(:all).each do |photo|
			paths << photo.picture.url
		end

		render :json => { :files => paths }.to_json
	end

end
