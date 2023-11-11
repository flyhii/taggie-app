# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../require_app'
require_app

HASHTAG_ID = '17842307719068454'
HASHTAG_NAME = 'new'
CONFIG = YAML.safe_load_file('config/secrets.yml')
INSTAGRAM_TOKEN = CONFIG['INSTAGRAM_TOKEN']
ACCOUNT_ID = CONFIG['ACCOUNT_ID']
CORRECT = YAML.safe_load_file('spec/fixtures/instagram_results.yml')
# CORRECT_HS = YAML.safe_load_file('spec/fixtures/hashtag_results.yml')

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'instagram_api'
