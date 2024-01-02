# frozen_string_literal: true

require_relative 'list_request'
require 'http'

module FlyHii
  module Gateway
    # Infrastructure to call FlyHii API
    class Api
      def initialize(config)
        @config = config
        @request = Request.new(@config)
      end

      def alive?
        @request.get_root.success?
      end

      def hashtags_list(list)
        @request.hashtags_list(list)
      end

      def add_posts(hashtag_name)
        @request.add_posts(hashtag_name)
      end

      # Gets rank of hashtags from API
      # - req: PostRequestPath
      #        with #hashtag_name
      def rank(req)
        @request.get_rank(req)
      end

      # HTTP request transmitter
      class Request
        def initialize(config)
          @api_host = config.API_HOST
          @api_root = "#{config.API_HOST}/api/v1"
        end

        def get_root # rubocop:disable Naming/AccessorMethodName
          call_api('get')
        end

        def hashtags_list(list)
          puts "list = #{list}"
          call_api('get', ['hashtags'],
                   'list' => Value::WatchedList.to_encoded(list))
        end

        def add_posts(hashtag_name)
          call_api('post', ['posts', hashtag_name])
        end

        def get_rank(req)
          call_api('get', ['rank',
                           req.hashtag_name])
        end

        private

        def params_str(params)
          params.map { |key, value| "#{key}=#{value}" }.join('&')
            .then { |str| str ? "?#{str}" : '' }
        end

        def call_api(method, resources = [], params = {})
          api_path = resources.empty? ? @api_host : @api_root
          puts "api_path = #{api_path}"
          url = [api_path, resources].flatten.join('/') + params_str(params)
          HTTP.headers('Accept' => 'application/json').send(method, url)
            .then { |http_response| Response.new(http_response) }
        rescue StandardError
          raise "Invalid URL request: #{url}"
        end
      end

      # Decorates HTTP responses with success/error
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)

        SUCCESS_CODES = (200..299)

        def success?
          code.between?(SUCCESS_CODES.first, SUCCESS_CODES.last)
        end

        def message
          payload['message']
        end

        def payload
          body.to_s
        end
      end
    end
  end
end
