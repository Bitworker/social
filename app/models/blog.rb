# encoding: UTF-8
class Blog < ActiveRecord::Base
	# Datenbankbeziehungen
	belongs_to :user
	has_many :posts, :order => "created_at DESC"
end
