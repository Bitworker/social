# encoding: UTF-8
# Be sure to restart your server when you modify this file.


SN::Application.config.session_store :cookie_store, :key => '_sG_Media_session_id'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")

# Auskommentiert um die Datenbank Cookies zu verwenden!
SN::Application.config.session_store :active_record_store
