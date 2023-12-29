# frozen_string_literal: true

require 'http'
require 'httparty'
require 'yaml'

module FlyHii
  module Gateway
    # Infrastructure to call Instagram API
    class Api
      def initialize(config)
        @config = config
        @request = Request.new(@config)
      end

      def alive?
        @request.get_root.success?
      end

      def projects_list(list)
        @request.projects_list(list)
      end

      def add_project(owner_name, project_name)
        @request.add_project(owner_name, project_name)
      end

      # Gets appraisal of a project folder rom API
      # - req: ProjectRequestPath
      #        with #owner_name, #project_name, #folder_name, #project_fullname
      def appraise(req)
        @request.get_appraisal(req)
      end

      # request url
      class Request
        def get_root # rubocop:disable Naming/AccessorMethodName
          call_api('get')
        end

        def posts_list(list)
          call_api('get', ['posts'],
                   'list' => Value::WatchedList.to_encoded(list))
        end

        def add_project(owner_name, project_name)
          call_api('post', ['posts', owner_name, project_name])
        end

        def get_appraisal(req)
          call_api('get', ['posts',
                           req.owner_name, req.project_name, req.folder_name])
        end

        private

        def params_str(params)
          params.map { |key, value| "#{key}=#{value}" }.join('&')
            .then { |str| str ? '?' + str : '' }
        end

        def call_api(method, resources = [], params = {})
          api_path = resources.empty? ? @api_host : @api_root
          url = [api_path, resources].flatten.join('/') + params_str(params)
          HTTP.headers('Accept' => 'application/json').send(method, url)
            .then { |http_response| Response.new(http_response) }
        rescue StandardError
          raise "Invalid URL request: #{url}"
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
          # use new HTTPRequestHandler
          response = HTTPRequestHandler.get(url)

          Response.new(response).tap do |inner_response|
            raise(inner_response.error) unless inner_response.successful?
          end
        end
      end

      # Decorates HTTP responses with success/error
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)

        SUCCESS_CODES = (200..299).freeze

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
