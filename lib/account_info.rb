# frozen_string_literal: true

require 'httparty'
require 'yaml'

config = YAML.safe_load_file('config/secrets.yml')
user_id = config['ACCOUNT_ID']
access_token = config['INSTAGRAM_TOKEN']
fields = 'id,ig_id,username,name'

instagram_response = {}
instagram_results = {}

# HAPPY account info request
account_url = "https://graph.facebook.com/v18.0/#{user_id}?fields=#{fields}&access_token=#{access_token}"

instagram_response[account_url] = HTTParty.get(account_url)
account_info = instagram_response[account_url].parsed_response

instagram_results['id'] = account_info['id']
# should be personal id

instagram_results['username'] = account_info['username']
# should be hw_flyhii

instagram_results['name'] = account_info['name']
# should be FLYHII

File.write('../spec/fixtures/instagram_results.yml', instagram_results.to_yaml)
