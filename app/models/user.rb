# encoding: UTF-8
class User < ActiveRecord::Base
	attr_accessor :remember_me
	attr_accessor :current_password 
	
	# Datenbankbeziehungen
	has_one :spec
	has_one :faq
	has_one :blog
	has_many :friendships
	has_many :friends,
					 :through => :friendships,
					 :conditions => "status = 'accepted'",
					 :order => :screen_name
	has_many :requested_friends,
					 :through => :friendships,
					 :source => :friend,
					 :conditions => "status = 'requested'",
					 :order => :created_at
	has_many :pending_friends,
			 		 :through => :friendships,
					 :source => :friend,
				 	 :conditions => "status = 'pending'",
					 :order => :created_at

	# Sicherheitsaspekt: Einbindung der SHA1 Verschlüsselung für den SecureCookie
	require 'digest/sha1'
	
	# Konstanten
	SCREEN_NAME_MIN_LENGTH = 4
	SCREEN_NAME_MAX_LENGTH = 40
	PASSWORD_MIN_LENGTH = 6
	PASSWORD_MAX_LENGTH = 40
	EMAIL_MAX_LENGTH = 50
	SCREEN_NAME_RANGE = SCREEN_NAME_MIN_LENGTH..SCREEN_NAME_MAX_LENGTH
	PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH
	SCREEN_NAME_SIZE = 20
	PASSWORD_SIZE = 10
	EMAIL_SIZE = 30
	
	# REGEX Konstanten
	SCREEN_NAME_REGEX = /^[A-Z0-9_]*$/i
	EMAIL_REGEX = /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i

	# Validierungen
	validates_format_of :screen_name,	:with => SCREEN_NAME_REGEX, :message => "darf nur aus Buchstaben, Zahlen und Unterstrichen bestehen."
	validates_format_of :email,	:with => EMAIL_REGEX, :message => "ist ungültig."
	validates_uniqueness_of :screen_name, :email
	validates_confirmation_of :password	
	validates_length_of :screen_name, :within => SCREEN_NAME_RANGE
	validates_length_of :password, :within => PASSWORD_RANGE
	validates_length_of :email, :maximum => EMAIL_MAX_LENGTH
	
  # Validierungs Methode für @ und Leerzeichen in Nutzernamen und EMail
	def validate
		errors.add(:email, "muss ein @ enthalten.") unless email.include?("@")
		if screen_name.include?(" ")
			errors.add(:screen_name, "darf keine Leerzeichen enthalten.")
		end
	end
	
	# Einloggen eines Users
	def login!(session)
			session[:user_id] = id
	end
	
	# Ausloggen eines Users
	def self.logout!(session, cookies)
		session[:user_id] = nil
		cookies.delete(:authorization_token)
	end

	# Sicherheitsaspekt: Löschen des Passworts (Darf im Formular nicht angezeigt werden)
	def clear_password!
		self.password = nil
		self.password_confirmation = nil
		self.current_password = nil
	end

	# Erstellen eines Erinnerungs Cookies
	# Sicherheitsaspekt: Der "authorization_token" wird mit SHA1 verschlüsselt
	def remember!(cookies)
		cookie_expiration = 10.years.from_now
		cookies[:remember_me] = { :value => "1",
															:expires => cookie_expiration }
		self.authorization_token = unique_identifier									
		cookies[:remember_me].force_encoding("UTF-8")
		save!
		cookies[:authorization_token] = { :value => authorization_token,
																			:expires => cookie_expiration }
	end

	# Setzt den User Loginstatus zurück
	def forget!(cookies)
		cookies.delete(:remember_me)
		cookies.delete(:authorization_token)
	end

	# Gibt den Wert wahr zurück falls der Benutzer eingelogt bleiben möchte
	def remember_me?
		remember_me == "1"
	end

	# Gibt den Wert wahr zurück wenn der Passwortvergleich stimmt
	def correct_password?(params)
		current_password = params[:user][:current_password]
		password == current_password
	end
	
	# Fehlermeldungen für Passwort fehler
	def password_errors(params)
		self.password = params[:user][:password]
		self.password_confirmation = params[:user][:password_confirmation]
		valid?
		# Das Passwort ist inkorekt, Fehlermeldung wird hinzugefügt
		errors.add(:current_password, "ist Falsch")
	end
	
	# Gibt den bestmöglichsten Benutzernamen wieder
	def name
		spec.full_name.or_else(screen_name)
	end

	def avatar
		Avatar.new(self)
	end

	private

	# Sicherheitsaspekt: Secure Cookie
	# Generiert einen geheimen identifizierer aus Email und Passwort
	def unique_identifier
		Digest::SHA1.hexdigest("#{email}:#{password}")
	end
end