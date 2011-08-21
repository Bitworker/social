# encoding: UTF-8
require 'test_helper'

class RememberMeTest < ActionDispatch::IntegrationTest
	include ApplicationHelper
	fixtures :users

  def setup
		@user = users(:valid_user)
	end
  
  def test_remember_me
		# Einloggen mit aktivierter erinnern chechbox
		post "user/login", :user => { :email => @user.email,
																	:password => @user.password,
																	:remember_me => "1" }
		# Simulation eines geschlossenes Browsers durch zurücksetzen der Session 
		@request.session[:user_id] = nil
		get "site/index"
		# Der check_authorization before_filter sollte uns ausloggen
		assert logged_in?
		assert_equal @user.id, session[:user_id]
	end
end