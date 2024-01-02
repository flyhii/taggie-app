# frozen_string_literal: true

require 'dry/transaction'

module FlyHii
  module Service
    # Retrieves array of all listed hashtags values
    class ListHashtags
      include Dry::Transaction

      step :get_api_list
      step :reify_list

      private

      def get_api_list(hashtags_list)
        puts "hashtaglist = #{hashtags_list}"
        Gateway::Api.new(FlyHii::App.config)
          .hashtags_list(hashtags_list)
          .then do |result|
            puts "hey"
            result.success? ? Success(result.payload) : Failure(result.message)
          end
      rescue StandardError
        puts "???"
        Failure('Could not access our API')
      end

      def reify_list(hashtags_json)
        puts "stage 1 success"
        Representer::HashtagsList.new(OpenStruct.new)
          .from_json(hashtags_json)
          .then { |hashtags| Success(hashtags) }
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end
