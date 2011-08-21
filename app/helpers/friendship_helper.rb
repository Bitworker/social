# encoding: UTF-8
module FriendshipHelper

	# Gibt die angeforderten Statusnachrichten wieder
	def friendship_status(user, friend)
		friendship = Friendship.find_by_user_id_and_friend_id(user, friend)
		return "Du bist nicht mit #{friend.name} befreundet." if friendship.nil?
		case friendship.status
			when 'requested'
			"#{friend.name} hat dir eine Freundesanfrage gesendet."
			when 'pending'
			"Du hast eine Freundesanfrage an #{friend.name} gesendet."
			when 'accepted'
			"#{friend.name} ist dein Freund."
		end
	end
end