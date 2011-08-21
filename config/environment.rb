# encoding: UTF-8
# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
SN::Application.initialize!

# Allgemeine UTF-8 Konvertierung 
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

