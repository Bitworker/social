# encoding: UTF-8
require 'test_helper' 

class UserTest < ActiveSupport::TestCase
	fixtures :users

	def setup
		@valid_user = users(:valid_user)
		@invalid_user = users(:invalid_user)
	end

	# Gültiger User bei der Überprüfung
	def test_user_validity
		assert @valid_user.valid?
	end

	# Ungültiger User bei der Überprüfung
	def test_user_invalidity
		assert !@invalid_user.valid?
			attributes = [:screen_name, :email, :password]
			attributes.each do |attribute|
			assert @invalid_user.errors.invalid?(attribute)
		end
	end

	# Test der validates_uniqueness_of :email (models/user.rb)
	def test_uniqueness_of_email
		user_repeat = User.new(:screen_name => @valid_user.screen_name, :email => @valid_user.email, :password => @valid_user.password)
		assert !user_repeat.valid?
	end
	
	# Sicherstellen das der Username nicht zu kurz ist
	def test_screen_name_minimum_length
		user = @valid_user
		min_length = User::SCREEN_NAME_MIN_LENGTH
	 	# Username ist zu kurz
		user.screen_name = "a" * (min_length - 1)
		assert !user.valid?, "#{user.screen_name} should raise a minimum length error"	
		# Username hat die minimal länge
		user.screen_name = "a" * min_length
		assert user.valid?, "#{user.screen_name} should be just long enough to pass"
	end
	
	# Sicherstellen das der Username nicht zu lang ist
	def test_screen_name_maximum_length
		user = @valid_user
		max_length = User::SCREEN_NAME_MAX_LENGTH
		# Username ist zu lang
		user.screen_name = "a" * (max_length + 1)
		assert !user.valid?, "#{user.screen_name} should raise a maximum length error"
		# Username hat die Maximale länge
		user.screen_name = "a" * max_length
		assert user.valid?, "#{user.screen_name} should be just short enough to pass"
	end
	
	# Sicherstellen das das Passwort nicht zu kurz ist
	def test_password_minimum_length
		user = @valid_user
		min_length = User::PASSWORD_MIN_LENGTH
		# Passwort ist zu kurz
		user.password = "a" * (min_length - 1)
		assert !user.valid?, "#{user.password} should raise a minimum length error"
		# Passwort ist lang genug
		user.password = "a" * min_length
		assert user.valid?, "#{user.password} should be just long enough to pass"
	end

	# Sicherstellen das das Passwort nicht zu lang ist
	def test_password_maximum_length
		user = @valid_user
		max_length = User::PASSWORD_MAX_LENGTH
		# Passwort ist zu lang
		user.password = "a" * (max_length + 1)
		assert !user.valid?, "#{user.password} should raise a maximum length error"
		# Passwort hat die Maximale länge
		user.password = "a" * max_length
		assert user.valid?, "#{user.password} should be just short enough to pass"
	end
	
	# Sicherstellen das die EMail nicht zu lang ist
	def test_email_maximum_length
		user = @valid_user
		max_length = User::EMAIL_MAX_LENGTH
		# Gültige EMail erstellen die nicht zu lang ist
		user.email = "a" * (max_length - user.email.length + 1) + user.email
		assert !user.valid?, "#{user.email} should raise a maximum length error"
	end
	
	# Test des EMail REGEX auf einer gültigen EMail adresse
	def test_email_with_valid_examples
		user = @valid_user
		valid_endings = %w{com org net edu es jp info}
		valid_emails = valid_endings.collect do |ending|
			"foo.bar_1-9@baz-quux0.example.#{ending}"
		end
		valid_emails.each do |email|
			user.email = email
			assert user.valid?, "#{email} must be a valid email address"
		end
	end
	
	# Test des EMail REGEX auf einer ungültigen EMail adresse
	def test_email_with_invalid_examples
		user = @valid_user
		invalid_emails = %w{foobar@example.c @example.com f@com foo@bar..com foobar@example.infod foobar.example.com foo,@example.com foo@ex(ample.com foo@example,com}
		invalid_emails.each do |email|
			user.email = email
			assert !user.valid?, "#{email} tests as valid but shouldn't be"
		end
	end
	
	# Test des Username REGEX auf einem gültigen Username
	def test_screen_name_with_valid_examples
		user = @valid_user
			valid_screen_names = %w{Peter Michael web_20}
			valid_screen_names.each do |screen_name|
			user.screen_name = screen_name
			assert user.valid?, "#{screen_name} should pass validation, but doesn't"
		end
	end

	# Test des Username REGEX auf einem ungültigen Username
	def test_screen_name_with_invalid_examples
		user = @valid_user
			invalid_screen_names = %w{rails/rocks web2.0 javscript:something}
			invalid_screen_names.each do |screen_name|
			user.screen_name = screen_name
			assert !user.valid?, "#{screen_name} shouldn't pass validation, but does"
		end
	end
	
	def test_screen_name_length_boundaries
		assert_length :min, @valid_user, :screen_name, User::SCREEN_NAME_MIN_LENGTH
		assert_length :max, @valid_user, :screen_name, User::SCREEN_NAME_MAX_LENGTH
	end

	def test_password_length_boundaries
		assert_length :min, @valid_user, :password, User::PASSWORD_MIN_LENGTH
		assert_length :max, @valid_user, :password, User::PASSWORD_MAX_LENGTH
	end
end