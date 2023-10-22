# frozen_string_literal: true

require 'http'
require 'httparty'
require 'yaml'
require_relative 'hashtag'
require_relative 'media'

module FlyHii
  # Library for Github Web API
  class InstagramApi
    API_PROJECT_ROOT = 'https://graph.facebook.com/v18.0'
    FIELDS = 'id,caption,comments_count,like_count,timestamp'

    module Errors
      class NotFound < StandardError; end
      class Unauthorized < StandardError; end
    end

    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      404 => Errors::NotFound
    }.freeze

    def initialize(token, user_id)
      @ig_token = token
      @ig_user_id = user_id
    end

    def hashtag(hashtag_name)
      hashtag_req_url = ig_api_path_hashtag(hashtag_name)
      hashtag_id = call_ig_url(hashtag_req_url).parsed_response
      hashtag = Hashtag.new(hashtag_id) # create Hashtag
      hashtag.store_data_hashtag
      hashtag.hashtag
    end

    # need hashtag_id from Hashtag
    def media(hashtag_id)
      media_req_url = ig_api_path_media(hashtag_id)
      media_data = call_ig_url(media_req_url).parsed_response
      media_data['data'].map do |data|
        media = Media.new(data)
        media.store_data
      end
    end

    def successful?(result)
      !HTTP_ERROR.keys.include?(result.code)
    end

    private

    def ig_api_path_hashtag(hashtag_name)
      "#{API_PROJECT_ROOT}/ig_hashtag_search?user_id=#{@ig_user_id}&q=#{hashtag_name}&access_token=#{@ig_token}"
    end

    def ig_api_path_media(hashtag_id)
      "#{API_PROJECT_ROOT}/#{hashtag_id}/top_media?user_id=#{@ig_user_id}&fields=#{FIELDS}&access_token=#{@ig_token}"
    end

    def call_ig_url(url)
      result = HTTParty.get(url)
      successful?(result) ? result : raise(HTTP_ERROR[result.code])
    end
  end

  # Decorates HTTP responses from Instagram with success/error reporting
  class Response < SimpleDelegator
    Unauthorized = Class.new(StandardError)
    NotFound = Class.new(StandardError)

    HTTP_ERROR = {
      401 => Unauthorized,
      404 => NotFound
    }.freeze

    def successful?
      HTTP_ERROR.keys.none?(code)
    end

    def error
      HTTP_ERROR[code]
    end
  end
end
