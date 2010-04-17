# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_makerfactory_session',
  :secret      => '74170e6308e0230f6bac64d7fcea445c67f20dc831458d6b4e0819b5ecbd62d5c0d5d7d4d45bbe0ae2827f0a137bb677f37f2848b6881471215d97309a182c50'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
