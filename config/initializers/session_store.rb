# Be sure to restart your server when you modify this file.

Mealness::Application.config.session_store :active_record_store, key: '_mealness_session'
ActiveRecord::SessionStore::Session.attr_accessible :data, :session_id

#Mealness::Application.config.session_store :cookie_store, key: '_mealness_session'
