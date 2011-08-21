# encoding: UTF-8
module AvatarHelper
	
	# Gibt den Bildnamen für das normale Benutzerbild wieder
	def avatar_tag(user)
		image_tag(user.avatar.url, :border => 1)
	end
	
	# Gibt den Bildnamen für das verkleinerte Benutzerbild wieder
	def thumbnail_tag(user)
		image_tag(user.avatar.thumbnail_url, :border => 1)
	end

	# Gibt den Bildnamen für das standard Benutzerbild wieder
	def default_avatar_tag
		image_tag("avatars/default_avatar.png", :border => 1)
	end
	
	# Gibt den Bildnamen für das verkleinerte standard Benutzerbild wieder
	def default_avatar_thumbnail_tag
		image_tag("avatars/default_avatar_thumbnail.png", :border => 1)
	end
end