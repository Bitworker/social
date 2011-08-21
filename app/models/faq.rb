# encoding: UTF-8
class Faq < ActiveRecord::Base
	# Datenbankbeziehungen
	belongs_to :user
	
	# Konstanten
	QUESTIONS = %w(bio faehigkeiten schulen firmen musik filme tv  magazine buecher)
	FAVORITES = QUESTIONS - %w(bio)
	TEXT_ROWS = 4
	TEXT_COLS = 70

	# Validierungen
	validates_length_of QUESTIONS, :maximum => DB_TEXT_MAX_LENGTH

	def initialize
		super
		QUESTIONS.each do |question|
			self[question] = ""
		end
	end
end