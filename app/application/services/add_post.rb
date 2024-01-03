# frozen_string_literal: true

require 'dry/transaction'

module FlyHii
  module Service
    # Transaction to store post from Instagram API to database
    class AddPost
      include Dry::Transaction

      step :validate_input
      step :request_post
      step :reify_post

      private

      def validate_input(input)
        puts '0'
        if input.success?
          hashtag_name = input[:hashtag_name]
          Success(hashtag_name:)
        else
          Failure(input.errors.values)
        end
      end

      def request_post(input)
        puts '1'
        result = Gateway::Api.new(FlyHii::App.config)
          .add_posts(input[:hashtag_name])

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot get posts right now; please try again later')
      end

      def reify_post(project_json)
        puts '2'
        Representer::Project.new(OpenStruct.new)
          .from_json(project_json)
          .then { |project| Success(project) }
      rescue StandardError
        Failure('Error in the project -- please try again')
      end
    end
  end
end
