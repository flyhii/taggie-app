# frozen_string_literal: true

require 'figaro'
require 'logger'
require 'rack/session'
require 'roda'
require 'yaml'
# require 'delegate' # needed until Rack 2.3 fixes delegateclass bug

module FlyHii
  # Environment-specific configuration
  class App < Roda
    plugin :environments

    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment:,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config = Figaro.env

    use Rack::Session::Cookie, secret: config.SESSION_SECRET

    # Logger Setup
    @logger = Logger.new($stderr)
    def self.logger = @logger

    configure :development, :test, :app_test do
      require 'pry'; # for breakpoints
    end
  end
end
