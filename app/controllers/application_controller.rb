# encoding: UTF-8
class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Sicherheitsaspekt: Die Ruby on Rails Funktion schützt gegen Cross-site Request Forgery (CSRF) attacken
  protect_from_forgery
  before_filter :check_authorization

  # Einzigartiger Cookiename zur Identifizierung
	session :session_key => '_sG_Media_session_id'
	
	# Überprüfen eines gültigen Authentifizierungscookies, Login nach Möglichkeit
	def check_authorization
		authorization_token = cookies[:authorization_token]
		if authorization_token and not logged_in?
			user = User.find_by_authorization_token(authorization_token)
			user.login!(session) if user
		end
	end
  
  # Gibt den Wert Wahr zurück, falls die weitergegebenen Parameter sowie das Objekt zusammenpassen.
	# Der Vergleich ist nötigt um sicherzustellen das der POST request nicht von sonst wo kommt.
  def param_posted?(sym)
		request.post? and params[sym]
  end

	# Eine Seite vor nicht eingelogten Usern schützen
	def protect
	# logged_in? befindet sich im ApplicationHelper
		unless logged_in?
			session[:protected_page] = request.request_uri
			flash[:notice] = "Bitte erst Einloggen!"
			redirect_to :controller => "user", :action => "login"
			return false
		end
	end

	def make_profile_vars
		@spec = @user.spec ||= Spec.new
		@faq = @user.faq ||= Faq.new
		@blog = @user.blog ||= Blog.new
		@posts = @blog.posts
	end
end