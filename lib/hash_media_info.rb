# frozen_string_literal: true

require 'httparty'
require 'yaml'

config = YAML.safe_load_file('config/secrets.yml')
user_id = config['ACCOUNT_ID']
access_token = config['INSTAGRAM_TOKEN']
fields = 'id,caption,comments_count,like_count,timestamp'
q = 'startup' # hashtag

instagram_response = {}
instagram_results = {}

# HAPPY account info request
hashtag_search_url = "https://graph.facebook.com/v18.0/ig_hashtag_search?user_id=#{user_id}&q=#{q}&access_token=#{access_token}"

instagram_response[hashtag_search_url] = HTTParty.get(hashtag_search_url)
hashtag_id = instagram_response[hashtag_search_url].parsed_response

ig_hashtag_id = hashtag_id['data'][0]['id']
# should be personal id

top_media_url = "https://graph.facebook.com/v18.0/#{ig_hashtag_id}/top_media?user_id=#{user_id}&fields=#{fields}&access_token=#{access_token}"

instagram_response[top_media_url] = HTTParty.get(top_media_url)
top_media = instagram_response[top_media_url].parsed_response

top_media['data'].map do |num|
  result = {}

  result['id'] = num['id']

  result['caption'] = num['caption']

  result['comments_count'] = num['comments_count']

  result['like_count'] = num['like_count']

  result['timestamp'] = num['timestamp']

  instagram_results[num['id']] = result
end

File.write('spec/fixtures/hashtag_id.yml', instagram_results.to_yaml)
