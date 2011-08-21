# encoding: UTF-8
class Post < ActiveRecord::Base
	# Datenbankbeziehungen
	belongs_to :blog

  # Validierungen
	validates_presence_of :title, :body, :blog
	validates_length_of :title, :maximum => DB_STRING_MAX_LENGTH
	validates_length_of :body, :maximum => DB_TEXT_MAX_LENGTH
	validates_uniqueness_of :body, :scope => [:title, :blog_id]	# Verhindert doppelte Nachrichten

	# Gibt den Wert wahr wieder falls der Titel/Inhalt identisch sind
	def duplicate?
		post = Post.find_by_blog_id_and_title_and_body(blog_id, title, body)
		self.id = post.id unless post.nil?
		not post.nil?
	end
end