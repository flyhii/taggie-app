# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

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
IG_URL = 'https://graph.facebook.com/v18.0/17842307719068454/top_media?user_id=17841462175987660&fields=id,caption,comments_count,like_count,timestamp,media_url,children,media_type&access_token=EAAJRl6PP8gYBO5Pwx2bxNkl2w9EsWWsIkozAZClASZAeeCxrw1WsaNvDjh0bUroAAuHczKVAyBdWSUgYJyjwl7NiUd3JUGb8yJ3hkpVENpZB1asHq7MfY6P8VWtZASpY4TWhmcZBaycvZCHvSRw0nhH91fcJRZAww5fnJWYtAawEyqGDG50yl5jjNC3'
INSTAGRAM_TOKEN = FlyHii::App.config.INSTAGRAM_TOKEN
ACCOUNT_ID = FlyHii::App.config.ACCOUNT_ID
CORRECT = YAML.safe_load_file('spec/fixtures/instagram_results.yml')
