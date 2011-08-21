# encoding: UTF-8
class FriendshipController < ApplicationController
	include ProfileHelper
	before_filter :protect, :setup_friends

	def create
		Friendship.request(@user, @friend)
		flash[:notice] = "Freundesanfrage wurde gesendet."
		redirect_to profile_for(@friend)
	end
	
	def accept
		if @user.requested_friends.include?(@friend)
			Friendship.accept(@user, @friend)
			flash[:notice] = "Du und #{@friend.screen_name} seid jetzt freunde!"
		else
			flash[:notice] = "Keine Freundschaftsanfrage von #{@friend.screen_name} erhalten."
		end
		redirect_to hub_url
	end
	
	def decline
		if @user.requested_friends.include?(@friend)
			Friendship.breakup(@user, @friend)
			flash[:notice] = "Freundesanfrage von #{@friend.screen_name} wurde abgelehnt!"
		else
			flash[:notice] = "Keine Freundschaftsanfrage von #{@friend.screen_name} erhalten."
		end
		redirect_to hub_url
	end

	def cancel
		if @user.pending_friends.include?(@friend)
			Friendship.breakup(@user, @friend)
			flash[:notice] = "Freundesanfrage wurde abgebrochen!"
		else
			flash[:notice] = "Keine Freundschaftsanfrage von #{@friend.screen_name} erhalten."
		end
		redirect_to hub_url
	end

	def delete
		if @user.friends.include?(@friend)
			Friendship.breakup(@user, @friend)
			flash[:notice] = "Freundschaft mit #{@friend.screen_name} wurde beendet!"
		else
			flash[:notice] = "#{@friend.screen_name} ist nicht dein Freund."
		end
		redirect_to hub_url
	end
		
	private
	
	def setup_friends
		@user = User.find(session[:user_id])
		@friend = User.find_by_screen_name(params[:id])
	end
end