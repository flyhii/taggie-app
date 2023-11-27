# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
require 'vcr'
require 'webmock'

require_relative '../init'

HASHTAG_ID = '17842307719068454'
HASHTAG_NAME = 'new'
INSTAGRAM_TOKEN = FlyHii::App.config.INSTAGRAM_TOKEN
ACCOUNT_ID = FlyHii::App.config.ACCOUNT_ID
CORRECT = YAML.safe_load_file('spec/fixtures/instagram_results.yml')
