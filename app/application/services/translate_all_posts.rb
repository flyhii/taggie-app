# frozen_string_literal: true

require 'dry/transaction'

module FlyHii
  module Service
    # Transaction to store post from Instagram API to database
    class TranslateAllPosts
      include Dry::Transaction

      step :request_post
      step :reify_post

      private

      def request_post(input)
        puts '1'
        # input_hash = { language: input }
        result = Gateway::Api.new(FlyHii::App.config)
          .translate_all_posts(input)

        result.success? ? Success(result.payload) : Failure(result.message)
        # input_hash[:response] = Gateway::Api.new(FlyHii::App.config)
        #   .translate_all_posts(input)
        # http_presenter = Representer::HttpResponse.new(OpenStruct.new).from_json(input_hash[:response].payload)
        # http_presenter.status == 'processing' ? Success(input) : Failure(http_presenter.message)

        # input[:response].success? ? Success(input.payload) : Failure(input[:response].message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot get posts right now; please try again later')
      end

      def reify_post(post_json)
        # unless post_json[:response].processing?
        unless post_json.processing?
          Representer::PostsList.new(OpenStruct.new) # rubocop:disable Style/OpenStructUse
            .from_json(post_json)
            .then { |post| Success(post) }
        end
      rescue StandardError
        Failure('Error in the post -- please try again')
      end
    end
  end
end
