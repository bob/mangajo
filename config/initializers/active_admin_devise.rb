module ActiveAdmin
  module Devise

    def self.controllers
      {
        :sessions => "active_admin/devise/sessions",
        :passwords => "active_admin/devise/passwords",
        :unlocks => "active_admin/devise/unlocks",
        :registrations => "active_admin/devise/registrations"
      }
    end

    class RegistrationsController < ::Devise::RegistrationsController
      include ::ActiveAdmin::Devise::Controller
    end

  end
end

