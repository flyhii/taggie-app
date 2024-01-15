# frozen_string_literal: true

require 'dry/transaction'

module FlyHii
  module Service
    # Transaction to store post from Instagram API to database
    class RankHashtags
      include Dry::Transaction

      step :validate_input
      step :request_ranked_hashtags
      step :reify_hashtags

      private

      def validate_input(input)
        puts "input = #{input}"
        if input
          hashtag_name = input
          Success(hashtag_name:)
        else
          Failure('Ranking failed')
        end
      end

      def request_ranked_hashtags(input)
        puts '2.1'
        result = Gateway::Api.new(FlyHii::App.config)
          .rank(input[:hashtag_name])
        puts "result = #{result}"
        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot get ranks right now; please try again later')
      end

      def reify_hashtags(post_json)
        Representer::RankedHashtags.new(OpenStruct.new) # rubocop:disable Style/OpenStructUse
          .from_json(post_json)
          .then { |post| Success(post) }
      rescue StandardError
        Failure('Error in the post -- please try again')
      end
    end
  end
end
