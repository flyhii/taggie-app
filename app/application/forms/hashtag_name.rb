# frozen_string_literal: true

require 'dry-validation'

module FlyHii
  module Forms
    # Form validation for Instagram hashtag
    class HashtagName < Dry::Validation::Contract
      HASHTAG_REGEX = /^[^\s#]+[a-zA-Z0-9_-]+[^\s#]+$/
      MSG_INVALID_FORMAT = 'Please enter a hashtag in the correct format'

      params do
        required(:hashtag_name).filled(:string)
      end

      rule(:hashtag_name) do
        puts 'rule'
        key.failure(MSG_INVALID_FORMAT) unless HASHTAG_REGEX.match?(value)
      end
    end
  end
end
