# frozen_string_literal: true

module FlyHii
  module Value
    # Hashtag in a post
    class Hashtag
      def initialize(hashtag_name)
        @hashtag_name = hashtag_name
      end

      def name
        @hashtag_name
      end
    end
  end
end
