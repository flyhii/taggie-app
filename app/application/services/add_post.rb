# frozen_string_literal: true

require 'dry/transaction'

module FlyHii
  module Service
    # Transaction to store project from Github API to database
    class AddPost
      include Dry::Transaction

      step :validate_input
      step :request_post
      step :reify_post

      private

      def validate_input(input)
        if input.success?
          hashtag_name = input[:hashtag_name]
          Success(hashtag_name:)
        else
          Failure(input.errors.messages)
        end
      end

      def request_post(input)
        result = Gateway::Api.new(FlyHii::App.config)
          .add_post(input[:hashtag_name])

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot add posts right now; please try again later')
      end

      def reify_post(post_json)
        Representer::Post.new(Struct.new)
          .from_json(post_json)
          .then { |post| Success(post) }
      rescue StandardError
        Failure('Error in the post -- please try again')
      end
    end
  end
end
