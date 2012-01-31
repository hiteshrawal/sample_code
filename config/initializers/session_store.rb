# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
#ActionController::Base.session = {
#  :key         => '_demoapp2_session',
#  :secret      => 'fb60fe22cabd222ec450e6cbd531be2453535da427980b1a8257535d6d579f27860f17a3fa844cd8b311d18111e647bf803edebf3bab32ab13689ecad766c9e2'
#}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
 ActionController::Base.session_store = :active_record_store
