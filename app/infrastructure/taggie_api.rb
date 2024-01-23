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

      def tranlate_all_posts(language)
        puts "wilmaaaa #{language}"
        @request.tranlate_all_posts(language)
      end

      def rank(req)
        puts "req = #{req}"
        @request.get_rank(req)
      end

      def get_recent_posts(hashtag_name)
        @request.get_recent_posts(hashtag_name)
      end

      def get_recent_rank(req)
        @request.get_recent_rank(req)
      end

      ############# new add 01/24 ########################
      def sort_posts_by_comment_counts(hashtag_name)
        @request.sort_posts_by_comment_counts(hashtag_name)
      end

      def get_comment_counts_rank(req)
        @request.get_comment_counts_rank(req)
      end
      ####################################################

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
          call_api('get', ['posts'],
                   'list' => Value::WatchedList.to_encoded(list))
        end

        def add_posts(hashtag_name)
          call_api('post', ['posts', hashtag_name])
        end

        def tranlate_all_posts(language)
          call_api('post', ['posts/translate', language])
        end

        def get_rank(req)
          call_api('get', ['posts', req])
        end

        def get_recent_posts(hashtag_name)
          call_api('get', ['recentposts', hashtag_name])
        end

        def get_recent_rank(req)
          call_api('get', ['recentposts', req])
        end

        ############# new add 01/24 ########################
        def sort_posts_by_comment_counts(hashtag_name)
          call_api('get', ['commentcountsposts', hashtag_name])  #have different: commentcountsposts
        end

        def get_comment_counts_rank(req)
          call_api('get', ['commentcountsposts', req])
        end
        ####################################################

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

        def failure?
          !success?
        end

        def ok?
          code == 200
        end

        def added?
          code == 201
        end

        def processing?
          code == 202
        end

        def message
          JSON.parse(payload)['message']
        end

        def payload
          body.to_s
        end
      end
    end
  end
end
