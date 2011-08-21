# encoding: UTF-8
module ApplicationHelper
	require 'string'
	
  # Helpermethode für link_to_unless_current
	def nav_link(text, controller, action="index")
		link_to_unless_current text, :id => nil,
																 :action => action,
															   :controller => controller
	end

	# Gibt Wahr wieder falls der Nutzer eingeloggt ist, sonst Falsch
	def logged_in?
		not session[:user_id].nil?
	end
end