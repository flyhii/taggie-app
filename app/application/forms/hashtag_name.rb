# frozen_string_literal: true

require 'dry-validation'

module FlyHii
  module Forms
    # Form validation for Github project URL
    class HashtagName < Dry::Validation::Contract
      HASHTAG_REGEX = /\b\#[a-zA-Z]+(?<!;)\b/
      MSG_INVALID_FORMAT = 'Please enter a hashtag in the correct format'

      params do
        required(:hashtag).filled(:string)
      end

      rule(:hashtag) do
        key.failure(MSG_INVALID_FORMAT) unless HASHTAG_REGEX.match?(value)
      end
    end
  end
end
