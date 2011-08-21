# encoding: UTF-8
require 'test_helper'

# Rückgabe von Fehlern durch den Controller
class SpecController; def rescue_action(e) raise e end; end

class SpecControllerTest < ActionController::TestCase
	fixtures :users
	fixtures :specs

	def setup
		@controller = SpecController.new
		@request = ActionController::TestRequest.new
		@response = ActionController::TestResponse.new
		@user = users(:valid_user)
		@spec = specs(:valid_spec)
	end

  def should_get_index
    get :index
    assert_response :success
  end

  def should_get_edit
    get :edit
    assert_response :success
  end
  
  def test_edit_success
		authorize @user
		post :edit,
			 	 :spec => { :vorname => "new first name",
			 	 :nachname => "new last name",
		 		 :geschlecht => "Male",
		 		 :arbeit => "new job",
				 :postleitzahl => "91125" }
		spec = assigns(:spec)
		new_user = User.find(spec.user.id)
		assert_equal new_user.spec, spec
	end
end