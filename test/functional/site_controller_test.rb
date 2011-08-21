# encoding: UTF-8
require 'test_helper'

class SiteControllerTest < ActionController::TestCase

  def should_get_index
    get :index  
    title = assigns(:title)
		assert_equal "Willkommen bei sG Media", title
		assert_response :success
		assert_template "index"
	end

  def should_get_about
    get :about
		title = assigns(:title)
		assert_equal "About sG Media", title
		assert_response :success
		assert_template "about"
	 end

  def should_get_help
    get :help
		title = assigns(:title)
		assert_equal "Hilfe zu sG Media", title
		assert_response :success
		assert_template "help"
	end
end