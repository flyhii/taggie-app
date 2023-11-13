# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../../require_app'
require_app

HASHTAG_ID = '17842307719068454'
HASHTAG_NAME = 'new'
# CONFIG = YAML.safe_load_file('config/secrets.yml')
# INSTAGRAM_TOKEN = CONFIG['INSTAGRAM_TOKEN']
# ACCOUNT_ID = CONFIG['ACCOUNT_ID']
INSTAGRAM_TOKEN = FlyHii::App.config.INSTAGRAM_TOKEN
ACCOUNT_ID = FlyHii::App.config.ACCOUNT_ID
CORRECT = YAML.safe_load_file('spec/fixtures/instagram_results.yml')
# CORRECT_HS = YAML.safe_load_file('spec/fixtures/hashtag_results.yml')
