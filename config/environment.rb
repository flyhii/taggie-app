# frozen_string_literal: true

require 'roda'
require 'yaml'

module FlyHii
  # Configuration for the App
  class App < Roda
    CONFIG = YAML.safe_load_file('config/secrets.yml')
    INSTAGRAM_TOKEN = CONFIG['INSTAGRAM_TOKEN']
    ACCOUNT_ID = CONFIG['ACCOUNT_ID']
  end
end
