# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_reader_session',
  :secret      => '3c04f1a61c6d6ee1c613af31c78a208129a38ec998a07b4ead60a0d8ba33cf22baa5155f9bc2a510820b124a42e362dff751ea34f4723bb2a33b5ed0fc00a27a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
