# encoding: UTF-8
require 'test_helper' 
require 'user_controller'

# Rückgabe von Fehlern durch den Controller
class UserController; def rescue_action(e) raise e end; end

class UserControllerTest < ActionController::TestCase
	include ApplicationHelper
 	fixtures :users

	def setup
		@controller = UserController.new
		@request = ActionController::TestRequest.new
		@response = ActionController::TestResponse.new
		# Ein bei der initialisierung gültiger Benutzer, wird später überschrieben
		@valid_user = users(:valid_user)
	end

	def test_registration_page
		get :register
		title = assigns(:title)
		assert_equal "Bei sG Media Registrieren", title
		assert_response :success
		assert_template "register"
		# Test des Formulars
		assert_form_tag "/user/register"
		assert_screen_name_field
		assert_email_field
		assert_password_field
		assert_password_field "password_confirmation"
		assert_submit_button "Senden"
	end

	# Test einer gültigen registration.
	def test_registration_success
		post :register, :user => { :screen_name => "neuer_benutzer_name", 
															 :email => "gueltige@email.de",
															 :password => "langes_passwort" }															 
		# Test der Benutzer Zuweisung.
		user = assigns(:user)
		assert_not_nil user
		# Test des neuen Benutzers in der Datenbank.
		new_user = User.find_by_screen_name_and_password(user.screen_name, user.password)
		assert_equal new_user, user
		# Test flash und Weiterleitung.
		assert_equal "Neuer Benutzer: #{new_user.screen_name} wurde erstellt!", flash[:notice]
		assert_redirected_to :action => "index"	
		# Sicherstellen das der Nutzer richtig eingelogt ist
		assert_not_nil logged_in?
		assert_equal user.id, session[:user_id]	
	end

	# Test einer ungültigen registration.
	def test_registration_failure
		post :register, :user => { :screen_name => "aa/noyes",
															 :email => "anoyes@example,com",
															 :password => "sun" }															 
		assert_response :success
		assert_template "register"
		# Test der Div Contrainer für die Fehlermeldungen.
		assert_tag "div", :attributes => { :id => "errorExplanation",
																		   :class => "errorExplanation" }																   
		# Auswahl das jedes Formfeld mindestens 1 Error anzeigt.
		assert_tag "li", :content => /Screen name/
		assert_tag "li", :content => /Email/
		assert_tag "li", :content => /Password/
		# Test ob die Eingabefelder in den richtigen Div Contrainern landen
		error_div = { :tag => "div", :attributes => { :class => "field_with_errors" } }
		assert_tag "input", :attributes => {  :name => "user[screen_name]",
							    												:value => "aa/noyes" },
																					:parent => error_div												
		assert_tag "input",	:attributes => { :name => "user[email]",
										 										 :value => "anoyes@example,com" },
																				 :parent => error_div
		assert_tag "input",		:attributes => { :name => "user[password]",
																					 :value => nil },
																				   :parent => error_div
	end

	# Sicherstellen das die Login Seite richtig ist
	def test_login_page
		get :login
		title = assigns(:title)
		assert_equal "In sG Media Einloggen", title
		assert_response :success
		assert_template "login"
		assert_tag "form", :attributes => { :action => "/user/login", 
																				:method => "post" }
		assert_tag "input", :attributes => { :name => "user[email]", 
																				 :type => "text",
																				 :size => User::EMAIL_SIZE,
																				 :maxlength => User::EMAIL_MAX_LENGTH }
		assert_tag "input",:attributes => { :name => "user[password]",
																				:type => "password",
																				:size => User::PASSWORD_SIZE,
																				:maxlength => User::PASSWORD_MAX_LENGTH }
		assert_tag "input", :attributes => { :type => "submit",
																				 :value => "Login!" }
		assert_tag "input", :attributes => { :name => "user[remember_me]",
																				 :type => "checkbox" }
		assert_tag "input", :attributes => { :type => "submit",
																				 :value => "Login!" }																				 
	end

	# Test eines gültigen Logins
	def test_login_success
		try_to_login @valid_user, :remember_me => "0"
		assert_equal @valid_user.id, session[:user_id]
		assert_equal "Benutzer #{@valid_user.screen_name} wurde eingelogt!", flash[:notice]
		assert_response :redirect
		assert_redirected_to :action => "index"
		# Sicherstellen das es sich nicht um einen "erinnerten" Benutzer handelt
 		user = assigns(:user)
 		assert user.remember_me != "1"
	end

	# Test eines gültigen Logins bei der die "erinnern" Funktion aktiviert ist
	def test_login_success_with_remember_me
		try_to_login @valid_user, :remember_me => "1"
		test_time = Time.now
		assert_equal @valid_user.id, session[:user_id]
		assert_equal "Benutzer #{@valid_user.screen_name} wurde eingelogt!", flash[:notice]
		assert_response :redirect
		assert_redirected_to :action => "index"
		# Enddatum des Cookies prüfen
		user = User.find(@valid_user.id)
		time_range = 100 # microseconds range for time agreement
		# Remember me cookie
		time_range
		# Authorization cookie
		time_range
	end
	
	# Test Login mit ungültigen Benutzernamen
	def test_login_failure_with_nonexistent_email
		invalid_user = @valid_user
		invalid_user.email = "no such email"
		try_to_login invalid_user
		assert_template "login"
		assert_equal "Ungültige User/Passwort kombination", flash[:notice]
		# Sicherstellen das der Benutzername angezeigt wird, aber nicht das Passwort
		user = assigns(:user)
		assert_nil user.password
	end

	# Test Login mit ungültigen Passwort
	def test_login_failure_with_wrong_password
		invalid_user = @valid_user
		# Konstrukt des ungültigen Passworts
		invalid_user.password += "baz"
		try_to_login invalid_user
		assert_template "login"
		assert_equal "Ungültige User/Passwort kombination", flash[:notice]
		# Sicherstellen das der Benutzername angezeigt wird, aber nicht das Passwort
		user = assigns(:user)
		assert_nil user.password
	end

	# Test der Ausloggen Funktion
	def test_logout
		try_to_login @valid_user, :remember_me => "1"
		get :logout
		assert_response :redirect
		assert_redirected_to :action => "index", :controller => "site"
		assert_equal "Du bist jetzt Ausgelogt", flash[:notice]
		assert !logged_in?
	end

	# Test der Index (Profil) Seite für nicht eingelogte User.
	def test_index_unauthorized
	# Sicherstellen das der Beforefilter arbeitet.
		get :index
		assert_response :redirect
		assert_redirected_to :action => "login"
		assert_equal "Bitte erst Einloggen!", flash[:notice]
	end
	
	# Test der Index (Profil) Seite für eingelogte User.
	def test_index_authorized
		authorize @valid_user
		get :index
		assert_response :success
		assert_template "index"
	end
	
	# Testen ob eine geschützte Seite nach dem Einloggen direkt geöffnet wird (Friendly URL forwarding)
	def test_login_friendly_url_forwarding
		user = { :screen_name => @valid_user.screen_name, :password => @valid_user.password }
		friendly_url_forwarding_aux(:login, :index, user)
	end

	# Testen ob eine geschützte Seite nach dem Registrieren direkt geöffnet wird (Friendly URL forwarding)
	def test_register_friendly_url_forwarding
		user = { :screen_name => "new_screen_name", :email => "valid@example.com", :password => "long_enough_password" }
		friendly_url_forwarding_aux(:register, :index, user)
	end

	# Testen der Editseite
	def test_edit_page
		authorize @valid_user
		get :edit
		title = assigns(:title)
		assert_equal "Basis Informationen", title
		assert_response :success
		assert_template "edit"
		# Testen des Formulars
		assert_form_tag "/user/edit"
		assert_email_field @valid_user.email
		assert_password_field "current_password"
		assert_password_field
		assert_password_field "password_confirmation"
		assert_submit_button "Ändern"
	end

	private
	
	# Testen der Login funktion mit einem User
	def try_to_login(user, options = {})
		user_hash = { :email => user.email,
									:password => user.password }
		user_hash.merge!(options)
		post :login, :user => user_hash
	end

	def friendly_url_forwarding_aux(test_page, protected_page, user)
		get protected_page
		assert_response :redirect
		assert_redirected_to :action => "login"
		post test_page, :user => user
	end

	# Gibt die Cookie Value des Symbol wieder
	def cookie_value(symbol)
		cookies[symbol.to_s].value.first
	end
	
	# Gibt das Cookie auslaufdatum in bezug auf der Symbol wieder
	def cookie_expires(symbol)
		cookies[symbol.to_s].expires
	end

	# Sicherstellen das das Email Feld richtig funktioniert
	def assert_email_field(email = nil, options = {})
		assert_input_field("user[email]", email, "text", User::EMAIL_SIZE, User::EMAIL_MAX_LENGTH, options)
	end
	
	# Sicherstellen das das Passwort Feld richtig funktioniert
	def assert_password_field(password_field_name = "password", options = {})
		# Sicherheitsaspekt: Das Passwort soll niemals im Formular erscheinen
		blank = nil
		assert_input_field("user[#{password_field_name}]", blank, "password", User::PASSWORD_SIZE, User::PASSWORD_MAX_LENGTH, options)
	end
	
	# Sicherstellen das das Benutzernamen Feld richtig funktioniert
	def assert_screen_name_field(screen_name = nil, options = {})
		assert_input_field("user[screen_name]", screen_name, "text", User::SCREEN_NAME_SIZE, User::SCREEN_NAME_MAX_LENGTH, options)
	end
end