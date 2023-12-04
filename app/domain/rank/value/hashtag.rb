# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module FlyHii
  module Entity
    # Domain entity for hashtag
    class Hashtag < Dry::Struct
      include Dry.Types

      attribute :hashtag_name, Strict::String

      def to_attr_hash
        { hashtag_name: }
      end
    end
  end
end
