# encoding: UTF-8
module ProfileHelper

	# Gibt die Benutzerprofil URL wieder
	def profile_for(user)
		profile_url(:screen_name => user.screen_name)
	end

	# Gibt Wahr wieder falls die "ändern" Links versteckt wurden
	def hide_edit_links?
		not @hide_edit_links.nil?
	end
end