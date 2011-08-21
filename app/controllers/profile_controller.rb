# encoding: UTF-8
class ProfileController < ApplicationController
	helper :avatar, :friendship

  def index
  	@title = "sG Media Profile"
  end

  def show
  	@hide_edit_links = true
  	screen_name = params[:screen_name]
		@user = User.find_by_screen_name(screen_name)
		if @user
			@title = "sG Media Profil von #{screen_name}"
			make_profile_vars
		else
			flash[:notice] = "Kein Benutzer mit dem Namen #{screen_name} in der sG Media Datenbank verfügbar!"
			redirect_to :action => "index"
		end
  end
end
