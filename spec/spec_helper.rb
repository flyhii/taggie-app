# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../lib/instagram_api'

# USERID = '17986576562521259'
# TIME_STAMP = '2023-10-21T18:33:05+0000'
HASHTAG_ID = '17842307719068454'
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
INSTAGRAM_TOKEN = CONFIG['INSTAGRAM_TOKEN']
ACCOUNT_ID = CONFIG['ACCOUNT_ID']
CORRECT = YAML.safe_load(File.read('spec/fixtures/top_media_results.yml'))
CORRECT_HS = YAML.safe_load(File.read('spec/fixtures/hashtag_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'instagram_api'
