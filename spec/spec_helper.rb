# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'

HASHTAG_ID = '17842307719068454'
HASHTAG_NAME = 'new'
CORRECT = YAML.safe_load_file('spec/fixtures/instagram_results.yml')
