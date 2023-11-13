# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

# require_relative 'contributor'

module FlyHii
  module Entity
    # Entity for a one line of code from a contributor
    class HashtagRanking
      def initialize(captions = GetCaption.sperate)
        @captions = captions
      end

      # sperate captions into hashtags
      def hashtags
        hashtags = @captions.map { |caption| caption.scan(/#([^\s]+)/) }
        puts hashtags
        count = hashtags.flatten.tally
        puts count
      end
    end
  end
end
