# encoding: UTF-8
class SiteController < ApplicationController

	def index
		@title = "Willkommen bei sG Media"
	end
	
	def about
		@title = "About sG Media"
	end
		
	def help
		@title = "Hilfe zu sG Media"
	end
end