# encoding: UTF-8
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
    fixtures :all

	# Test des Form Tags
	def assert_form_tag(action)
		assert_tag "form", :attributes => { :action => action,
																				:method => "post" }
	end

	# Test eines Submit Buttons mit optionalem Label
	def assert_submit_button(button_label = nil)
		if button_label
			assert_tag "input", :attributes => { :type => "submit",
																					 :value => button_label}
		else
			assert_tag "input", :attributes => { :type => "submit" }
		end
	end

	# Test ob zu einem Formular attribute gehören
	def assert_input_field(name, value, field_type, size, maxlength, options = {})
		attributes = { :name => name,
									 :type => field_type,
									 :size => size,
									 :maxlength => maxlength }
		attributes[:value] = value unless value.nil?
		tag = { :tag => "input", :attributes => attributes }
		tag.merge!(options)
		assert_tag tag
	end

	# Testet die min und max länge von boundary Attributen
	def assert_length(boundary, object, attribute, length, options = {})
		valid_char = options[:valid_char] || "a"
		barely_invalid = barely_invalid_string(boundary, length, valid_char)
		object[attribute] = barely_invalid
		assert !object.valid?,
			"#{object[attribute]} (length #{object[attribute].length}) " +
			"should raise a length error"
			object.errors.on(attribute)
		barely_valid = valid_char * length
		object[attribute] = barely_valid
		assert object.valid?,
			"#{object[attribute]} (length #{object[attribute].length}) " +
			"should be on the boundary of validity"
	end
	
	# Erzeugt ein ungültiges boundary Attribut
	def barely_invalid_string(boundary, length, valid_char)
		if boundary == :max
			invalid_length = length + 1
		elsif boundary == :min
			invalid_length = length - 1
		else
			raise ArgumentError, "boundary must be :max or :min"
		end
		valid_char * invalid_length
	end

	# Gibt die Fehlermeldung für das boundary min/max Attribut
	def correct_error_message(boundary, length)
		if boundary == :max
			sprintf(error_messages[:too_long], length)
		elsif boundary == :min
			sprintf(error_messages[:too_short], length)
		else
		raise ArgumentError, "boundary must be :max or :min"
		end
	end

	# Authorisieren eines Benutzers
	def authorize(user)
		@request.session[:user_id] = user.id
	end

	# Simulieren eines Dateiuploads
	def uploaded_file(filename, content_type)
			t = Tempfile.new(filename)
			t.binmode
			path = RAILS_ROOT + "/test/fixtures/" + filename
			FileUtils.copy_file(path, t.path)
			(class << t; self; end).class_eval do
			alias local_path path
			define_method(:original_filename) {filename}
			define_method(:content_type) {content_type}
		end
		return t
	end
end