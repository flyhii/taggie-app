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
    
    # test.rb裡面的 ig_api = FlyHii::InstagramApi.new(access_token, user_id)過來
    def initialize(token, user_id)
      @ig_token = token
      @ig_user_id = user_id
      #puts "#{@ig_token} #{@ig_user_id}" 可正確追蹤到ID以及TOKEN
    end

    def hashtag(hashtag_name)
      #puts "#{@ig_token} #{@ig_user_id}"
      hashtag_response = Request.new(API_PROJECT_ROOT, @ig_user_id, @ig_token)
                                .hashtag_url(hashtag_name) #.parse #HTTParty::Response 对象没有 parse 方法
      #puts hashtag_response # 輸出{"data":[{"id":"17842307719068454"}]}                       
      hashtag = Hashtag.new(hashtag_response) 
      #puts hashtag.hashtag_id #ask為甚麼不行
      #puts hashtag # 輸出 <FlyHii::Hashtag:0x00007f34d922dfc0>
      hashtag.store_data_hashtag #是寫在這裡嗎?
    end

    # need hashtag_id from Hashtag
    def media(hashtag_id)
      media_response = Request.new(API_PROJECT_ROOT, @ig_user_id, @ig_token)
                          .media_url(hashtag_id).parsed_response 
      media_response['data'].each do |data|
        media = Media.new(data)
        media.store_data
      end
      # if media_response.nil?
      #   puts "No media data found."
      # else
      #   #puts media_response
      #   #puts "there are media_response" #這裡media_response是有抓到的
      #   media_response['data'].each do |data|
      #     media = Media.new(data)
      #     media.store_data
      #   end
      # end
    end
    
    # def successful?(result)
    #   !HTTP_ERROR.keys.include?(result.code)
    # end

    # def call_ig_url(url)
    #   result = HTTParty.get(url)
    #   successful?(result) ? result : raise(HTTP_ERROR[result.code])
    # end

    # Sends out HTTP requests to Github
    class Request
      def initialize(resource_root, ig_user_id, token)
        @resource_root = resource_root
        @user_id = ig_user_id
        @token = token
      end

      def hashtag_url(hashtag_name)
        url = "#{@resource_root}/ig_hashtag_search?user_id=#{@user_id}&q=#{hashtag_name}&access_token=#{@token}"
        #puts url
        get(url) #将响应数据解析为 HTTParty::Response 对象
      end

      def media_url(hashtag_id)
        url = "#{@resource_root}/#{hashtag_id}/top_media?user_id=#{@user_id}&fields=#{FIELDS}&access_token=#{@token}"
        get(url) #将响应数据解析为 HTTParty::Response 对象
      end

      def get(url)
        http_response = HTTParty.get(url) 
        #發送一個HTTP GET請求 #參數url是所要求的url地址 會返回響應的數據
        Response.new(http_response).tap do |response|
          raise(response.error) unless response.successful?
        end
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
end
