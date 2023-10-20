# frozen_string_literal: true

require 'httparty'
require 'yaml'

config = YAML.safe_load_file('config/secrets.yml')
user_id = config['ACCOUNT_ID']
access_token = config['INSTAGRAM_TOKEN']
fields = 'account_type,id,media_count,username'

instagram_response = {}
instagram_results = {}

# HAPPY account info request
account_url = "https://graph.instagram.com/#{user_id}?fields=#{fields}&access_token=#{access_token}"
instagram_response[account_url] = HTTParty.get(account_url)
account_info = instagram_response[account_url].parsed_response

instagram_results['account_type'] = account_info['account_type']
# should be personal

# instagram_results['id'] = account_info['id']
# should be personal id

instagram_results['media_count'] = account_info['media_count']
# should be 1

instagram_results['username'] = account_info['username']
# should be blue2cat_15

File.write('spec/fixtures/instagram_results.yml', instagram_results.to_yaml)
