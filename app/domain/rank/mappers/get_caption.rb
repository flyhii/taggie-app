# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

# require_relative 'contributor'

module FlyHii
  module Entity
    # Entity for a one line of code from a contributor
    class GetCaption
      def initialize(media = GetMedia.call)
        @media = media
      end

      # sperate media into captions
      def speration
        @media.map { |media| media['caption'] }
      end
    end
  end
end
