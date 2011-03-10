# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_file_upload_demo_session',
  :secret      => 'f8751ef9d7a474721ffe73b1ef219d094780003fa7b117193cd4c9323d07a9fa4611c78e2d11ed3ed0a2d8fff2aa1d2fe407b7c318eb5777cbd9157193bfd62f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
