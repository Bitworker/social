# encoding: UTF-8
class CommunityController < ApplicationController
	helper :profile
	
	def index
		@title = "Gemeinschaft"
		@letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
		if params[:id]
			@initial = params[:id]
			specs = Spec.find(:all,
												:conditions => ["nachname LIKE ?", @initial+'%'],
												:order => "nachname")
			@users = specs.collect { |spec| spec.user }
		end
	end
	
	def search
		# Die Suchfunktion ist noch nicht integriert.
	end
end