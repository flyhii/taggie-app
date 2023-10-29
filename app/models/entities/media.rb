# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

require_relative 'hashtag'

module FlyHii
  module Entity
    # Domain entity for any coding media info
    class Media < Dry::Struct
      include Dry.Types

      attribute :id, Strict::String
      attribute :caption, Strict::String
      attribute :comments_count, Strict::Integer
      attribute :like_count, Strict::Integer
      attribute :timestamp,   Strict::String
      attribute :media_url,   Strict::String
      attribute :children, Strict::String
      attribute :media_type, Strict::String
      # attribute :owner,     Member
      # attribute :members,   Strict::Array.of(Member)
    end
  end
end
