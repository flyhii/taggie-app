# frozen_string_literal: true

require 'dry/transaction'

module FlyHii
  module Service
    # Transaction to store post from Instagram API to database
    class AddRecentPost
      include Dry::Transaction

      step :validate_input
      step :request_post
      step :reify_post

      private

      def validate_input(input)
        puts '3.0'
        if input
          hashtag_name = input
          Success(hashtag_name:)
        else
          Failure('Please input a hashtag in the correct format')
        end
      end

      def request_post(input)
        puts '3.1'
        result = Gateway::Api.new(FlyHii::App.config)
          .get_recent_posts(input[:hashtag_name])

        puts "result = #{result}"

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot get recent posts right now; please try again later')
      end

      def reify_post(post_json)
        Representer::RecentPostsList.new(OpenStruct.new) # rubocop:disable Style/OpenStructUse
          .from_json(post_json)
          .then { |post| Success(post) }
      rescue StandardError
        Failure('Error in the post -- please try again')
      end
    end
  end
end
