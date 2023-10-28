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
    FIELDS = 'id,caption,comments_count,like_count,timestamp, media_url, children, media_type'
    def initialize(token, user_id)
      @ig_token = token
      @ig_user_id = user_id
    end

    def hashtag(hashtag_name)
      hashtag_response = Request.new(API_PROJECT_ROOT, @ig_user_id, @ig_token)
                                .hashtag_url(hashtag_name)
      hashtag = Hashtag.new(hashtag_response)
      hashtag.store_data_hashtag
    end

    def media(hashtag_id)
      media_response = Request.new(API_PROJECT_ROOT, @ig_user_id, @ig_token)
                              .media_url(hashtag_id).parsed_response
      media_response['data'].each do |data|
        media = Media.new(data)
        media.store_data
      end
    end

    # request url
    class Request
      def initialize(resource_root, ig_user_id, token)
        @resource_root = resource_root
        @user_id = ig_user_id
        @token = token
      end

      def hashtag_url(hashtag_name)
        url = "#{@resource_root}/ig_hashtag_search?user_id=#{@user_id}&q=#{hashtag_name}&access_token=#{@token}"
        InstagramApiResponseHandler.handle(url)
      end

      def media_url(hashtag_id)
        url = "#{@resource_root}/#{hashtag_id}/top_media?user_id=#{@user_id}&fields=#{FIELDS}&access_token=#{@token}"
        InstagramApiResponseHandler.handle(url)
      end
    end

    # increase one module to deal with HTTP request
    module HTTPRequestHandler
      def self.get(url)
        HTTParty.get(url)
      end
    end

    # take the get url response
    class InstagramApiResponseHandler
      def self.handle(url)
        response = HTTPRequestHandler.get(url) # use new HTTPRequestHandler
        Response.new(response).tap do |inner_response|
          raise(inner_response.error) unless inner_response.successful?
        end
      end
    end

    # Decorates HTTP responses from Instagram with success/error reporting
    class Response < SimpleDelegator
      # Represents an unauthorized access error
      Unauthorized = Class.new(StandardError)
      # Represents a not found error
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
end
