# encoding: UTF-8
require 'test_helper'

# Rückgabe von Fehlern durch den Controller
class FriendshipController; def rescue_action(e) raise e end; end

class FriendshipControllerTest < ActionController::TestCase
	include ProfileHelper
	fixtures :users, :specs

	def setup
		@controller = FriendshipController.new
		@request = ActionController::TestRequest.new
		@response = ActionController::TestResponse.new
		@user = users(:valid_user)
		@friend = users(:friend)
	end
	
	def test_create
		# Als Benutzer einloggen und eine Anfrage stellen
		authorize @user
		get :create, :id => @friend.screen_name
		assert_response :redirect
		assert_redirected_to profile_for(@friend)
		assert_equal "Freundesanfrage wurde gesendet.", flash[:notice]
		# Log in as friend and accept request.
		authorize @friend
		get :accept, :id => @user.screen_name
		assert_redirected_to hub_url
		assert_equal "Du und #{@user.screen_name} seid jetzt freunde!", flash[:notice]
	end
end