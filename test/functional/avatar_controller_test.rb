# encoding: UTF-8
require 'test_helper'

# Rückgabe von Fehlern durch den Controller
class AvatarController; def rescue_action(e) raise e end; end

class AvatarControllerTest < ActionController::TestCase
	fixtures :users
	
	def setup
		@controller = AvatarController.new
		@request = ActionController::TestRequest.new
		@response = ActionController::TestResponse.new
		@user = users(:valid_user)
	end
	
	def test_upload_and_delete
		authorize @user
		image = uploaded_file("rails.png", "image/png")
		post :upload, :avatar => { :image => image }
		assert_response :redirect
		assert_redirected_to hub_url
		assert_equal "Dein Bild wurde geuploadet.", flash[:notice]
		assert @user.avatar.exists?
		post :delete
		assert !@user.avatar.exists?
	end
end