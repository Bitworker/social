# encoding: UTF-8
class AvatarController < ApplicationController
 	before_filter :protect

	def index
		redirect_to hub_url
	end

	def upload
		@title = "Bild uploaden"
		@user = User.find(session[:user_id])
		if param_posted?(:avatar)
			image = params[:avatar][:image]
			@avatar = Avatar.new(@user, image)
			if @avatar.save
				flash[:notice] = "Dein Bild wurde geuploadet."
				redirect_to hub_url
			end
		end
	end
	
	def delete
		user = User.find(session[:user_id])
		user.avatar.delete
		flash[:notice] = "Dein Bild wurde entfernt."
		redirect_to hub_url
	end
end