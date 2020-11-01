require 'open-uri'
class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_headers
  
    protected

    def set_headers
      remote_ip = open('http://whatismyip.akamai.com').read
      response.set_header('Used-Instance', remote_ip)
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :username])
    end
  end