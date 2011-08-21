# encoding: UTF-8
require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# YAML Engine starten f�r Fixture .yml (Test UNITS)
require 'yaml' 
YAML::ENGINE.yamler= 'syck' 