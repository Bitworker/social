# encoding: UTF-8
class String
	# Gibt ein alternativen String falls er leer ist
	def or_else(alternate)
		blank? ? alternate : self
	end
end