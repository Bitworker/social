# encoding: UTF-8
class FaqController < ApplicationController
	before_filter :protect

	def index
		redirect_to hub_url
	end

	def edit
		@title = "FAQ ändern."
		@user = User.find(session[:user_id])
		@user.faq ||= Faq.new
		@faq = @user.faq
		if param_posted?(:faq)
			if @user.faq.update_attributes(params[:faq])
				flash[:notice] = "FAQ wurde geändert."
				redirect_to hub_url
			end
		end
	end
end