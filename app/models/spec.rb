# encoding: UTF-8
class Spec < ActiveRecord::Base
	# Datenbankbeziehungen
	belongs_to :user

	# Konstanten
	ALL_FIELDS = %w(vorname nachname arbeit geschlecht geburtstag stadt land postleitzahl)
	STRING_FIELDS = %w(vorname nachname arbeit geschlecht stadt land )
	VALID_GENDERS = ["Mann", "Frau"]
	START_YEAR = 1900
	VALID_DATES = DateTime.new(START_YEAR)..DateTime.now
	ZIP_CODE_LENGTH = 5

	# Validierungen
	validates_length_of STRING_FIELDS,
		:maximum => 255
	validates_inclusion_of :geschlecht,
		:in => VALID_GENDERS,
		:allow_nil => true,
		:message => "Muss männlich oder weiblich sein"		
	validates_inclusion_of :geburtstag,
		:in => VALID_DATES,
		:allow_nil => true,
		:message => "ist ungültig"	
	validates_format_of :postleitzahl, 
		:with => /(^$|^[0-9]{#{ZIP_CODE_LENGTH}}$)/,
		:message => "Die Postleitzahl muss 5 stellen haben"

	# Gibt den vollen Namen zurück
	def full_name
		[vorname, nachname].join(" ")
	end

	# Gibt die volle Anschrift zurück
	def location
		[stadt, land, postleitzahl].join(" ")
	end

	# Gibt das Alter mithilfe des Geburtsjahres wieder
	def age
		return if geburtstag.nil?
		today = Date.today
			if today.month >= geburtstag.month and today.day >= geburtstag.day
			# Geburtstag war bereits dieses Jahr
			today.year - geburtstag.year
			else
			today.year - geburtstag.year - 1
		end
	end
end