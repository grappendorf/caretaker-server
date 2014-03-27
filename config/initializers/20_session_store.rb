# Be sure to restart your server when you modify this file.

#CoyohoServer::Application.config.session_store :cookie_store, key: '_coyoho-server_session'
CoyohoServer::Application.config.session_store :redis_store, key: '_coyoho-server_session', servers: {host: Settings.redis.host, port: Settings.redis.port, namespace: 'session:coyoho-server' }

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# CoyohoServer::Application.config.session_store :active_record_store
