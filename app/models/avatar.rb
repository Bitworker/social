# encoding: UTF-8
class Avatar 
	include ActiveModel::Validations

	# Testumgebung /tmp else Bildverzeichnis /public/images/avatars
	if ENV["RAILS_ENV"]=="test"
		URL_STUB=DIRECTORY="tmp"
	else
		URL_STUB="/images/avatars"
		DIRECTORY=File.join("public","images","avatars")
	end

	# Konstanten
	IMG_SIZE = '"240x300>"'
	THUMB_SIZE = '"50x64>"'

	# Variablen 
	def initialize(user, image = nil)
		@user = user
		@image = image
	end
	
	def exists?
		File.exists? (File.join(DIRECTORY, filename))
	end
	
	alias exist? exists?
	
	def url
		"#{URL_STUB}/#{filename}"
	end
	
	def thumbnail_url
		thumb = exists? ? thumbnail_name : "avatars/default_thumbnail.png" "#{URL_STUB}/#{thumb}"
	end
	
	# Bild speichern
	def save
		valid_file? and successful_conversion?
	end
	
	# Bild löschen
	def delete
		[filename, thumbnail_name].each do |name|
		image = "#{DIRECTORY}/#{name}"
		File.delete(image) if File.exists?(image)
		end
	end
	
	private
	
	def filename
		"#{@user.screen_name}.png"
	end
	
	def thumbnail_name
		"#{@user.screen_name}_thumbnail.png"
	end
	
	# Gibt den Systemspezifischen Pfad für ImageMagick an
	def convert
		if ENV["OS"] =~ /Windows/
		 # Set this to point to the right Windows directory for ImageMagick.
		 "C:\\Program Files (x86)\\ImageMagick-6.7.1-Q16\\convert"
		else
		 "/usr/bin/convert"
		end
	end
	
	# Anpassung des Dateinamens, sicherstellen der Speicherung, Umwandelung durch ImageMagick
	def successful_conversion?
		# Anpassung des Dateinamens
		source = File.join("tmp", "#{@user.screen_name}_full_size")
		full_size = File.join(DIRECTORY, filename)
		thumbnail = File.join(DIRECTORY, thumbnail_name)
		# Sicherstellen das beide Bilder als normale Datei gespeichert wurden
    File.open(source,"wb"){|f| f.write(@image.read) }
    # Umwandelung der Dateien durch ImageMagick (konvertiert in PNG)
		img=system("convert #{source} -resize 240x330 #{full_size}")
		thumb=system("convert #{source} -resize 50x64 #{thumbnail}")
		# Beide Umwandelungen müssen erfolgreich sein, sonst Fehlerausgabe
		unless img and thumb
			errors.add(:base,"Bild Upload fehlgeschlagen. Versuch ein anderes Bild!")
			return false
		end
		return true
	end
	
	# Gibt den Wert wahr wieder falls es sich um eine nicht leere Bilddatei handelt.
	def valid_file?
		unless @image.content_type =~ /^image/
			errors.add(:base, "Die Datei ist kein Bild")
			return false
		end
		if @image.size > 2.megabyte
			errors.add(:image, "muss kleiner als 2MB sein.")
			return false
		end
		return true
	end
end