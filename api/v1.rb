# Prevent need for require_relative
$LOAD_PATH << File.expand_path('..', __FILE__)
require 'sinatra/base'
require 'sinatra/reloader'
require 'bugsnag'
require './config/bugsnag'
require 'v1/routes'
require 'zip'

module V1
  class App < Sinatra::Application
    configure :development do
      register Sinatra::Reloader
    end

    configure do
      enable :raise_errors
      set :protection, except: [:json_csrf]
    end

    not_found do
      halt 404, { error: "endpoint '#{request.path}' not found." }.to_json
    end

    error 500 do
      Bugsnag.auto_notify($ERROR_INFO, nil, request)
      msg = "So sorry! We've been notified of the error and will investigate."
      { error: msg }.to_json
    end

    use Routes::Exercises
  end
end