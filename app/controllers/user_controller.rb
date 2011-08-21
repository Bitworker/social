# encoding: UTF-8
class UserController < ApplicationController
	include ApplicationHelper
	helper :profile, :avatar
	# Sicherheitsaspekt: Schützt bestimmte Seiten und zwingt zum Login falls keine Session besteht
	before_filter :protect, :only => [:index, :edit, :edit_password]

  def index
  	@title = "sG Media Benutzer Daten"
		@user = User.find(session[:user_id])
		make_profile_vars
  end

	def register
		@title = "Bei sG Media Registrieren"
		if param_posted?(:user)
			@user = User.new(params[:user])
			if @user.save
				# Session wird hier verwendet damit man nach der Registrierung eingelogt ist.
				@user.login!(session)
				flash[:notice] = "Neuer Benutzer: #{@user.screen_name} wurde erstellt!"
				redirect_to_forwarding_url
			else
				@user.clear_password!	
			end
		end
	end

	def login
		@title = "In sG Media Einloggen"
		if request.get?
			@user = User.new(:remember_me => remember_me_string)
		elsif param_posted?(:user)
			@user = User.new(params[:user])
			user = User.find_by_email_and_password(@user.email,@user.password)
			if user		
				user.login!(session)
				# Der aufbau => boolean? ? do_one_thing : do_something_else entspricht einer IF-ELSE-Schleife
				# Sicherheitsaspekt: Verwendung eines Secure Cookies
				@user.remember_me? ? user.remember!(cookies) : user.forget!(cookies)
				flash[:notice] =  "Benutzer #{user.screen_name} wurde eingelogt!"
				redirect_to_forwarding_url
			else
				# Sicherheitsaspekt: Passwort darf im Formular nicht angezeigt werden.
				@user.clear_password!
				flash[:notice] = "Ungültige User/Passwort kombination"
			end
		end
	end
		
	def logout
		User.logout!(session, cookies)
		flash[:notice] = "Du bist jetzt Ausgelogt"
		redirect_to :action => "index", :controller => "site"
	end

	def edit
		@title = "Basis Informationen"
		@user = User.find(session[:user_id])
		if param_posted?(:user)
			attribute = params[:attribute]
			case attribute
				when "email"
					try_to_update @user, attribute
				when "password"
					if @user.correct_password?(params)
						try_to_update @user, attribute
					else
						@user.password_errors(params)
					end
			end
		end
		# Sicherheitsaspekt: Passwort darf im Formular nicht angezeigt werden.
		@user.clear_password!
	end
	
	private
		
	# Weiterleitung an die zuvor angeforderte URL (Falls verfügbar)
	# geschützte Seite -> Zwangs Login -> zugängliche geschützte Seite
	def redirect_to_forwarding_url
		if (redirect_url = session[:protected_page])
			session[:protected_page] = nil
			redirect_to redirect_url
		else
			redirect_to :action => "index"
		end
	end
		
	# Gibt einen String mit dem Status der "Eingelogt bleiben?" Checkbox wieder
	def remember_me_string
		cookies[:remember_me] || "0"
	end
		
	# Update von Benutzerdaten sowie Weiterleitung
	def try_to_update(user, attribute)
		if user.update_attributes(params[:user])
			flash[:notice] = "Benutzer #{attribute} wurde geändert."
			redirect_to :action => "index"
		end
	end		
end