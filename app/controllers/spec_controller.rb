# encoding: UTF-8
class SpecController < ApplicationController
	before_filter :protect

	def index
		redirect_to :controller => "user", :action => "index"
	end

	def edit
		@title = "Detail Informationen"
		@user = User.find(session[:user_id])
		@user.spec ||= Spec.new
		@spec = @user.spec
		if param_posted?(:spec)
			if @user.spec.update_attributes(params[:spec])
				flash[:notice] = "Änderungen wurden gespeichert!"
				redirect_to :controller => "user", :action => "index"
			end
		end
	end
end