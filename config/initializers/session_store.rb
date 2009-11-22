# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_stream_session',
  :secret      => '8e940d84eb02c323ed41bd0c3cc63c0f527d97fa19086372981cca8916b13fe22f5440adf7ab245464de7653ce7a466634f01f160de2b7d462de0e3c8e802556'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
