# frozen_string_literal: true

require 'dry/transaction'

module FlyHii
  module Service
    # Transaction to store post from Instagram API to database
    class RankHashtags
      include Dry::Transaction

      step :validate_input
      step :request_ranked_hashtags

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

      def request_ranked_hashtags(input)
        puts '1'
        result = Gateway::Api.new(FlyHii::App.config)
          .rank(input[:hashtag_name])

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot get ranks right now; please try again later')
      end
    end
  end
end
