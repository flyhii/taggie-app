# frozen_string_literal: true

module Views
  # View for a single post entity
  class TranslatePost
    def initialize(post, index = nil)
      @post = post
      @index = index
    end

    def entity
      @post
    end

    def index_str
      @index
    end

    def caption
      @post.trans_caption
    end

    def tags
      @post.tags
    end

    def comments_count
      @post.comments_count
    end

    def like_count
      @post.like_count
    end

    def timestamp
      @post.timestamp
    end

    def media_url
      @post.media_url
    end
  end
end

# class Post < Dry::Struct
#   include Dry.Types

#   attribute :id,              Integer.optional
#   attribute :remote_id,       Strict::String
#   attribute :caption,         Strict::String
#   attribute :tags,            Strict::String
#   attribute :comments_count,  Strict::Integer
#   attribute :like_count,      Strict::Integer.optional
#   attribute :timestamp,       Strict::Time
#   attribute :media_url,       Strict::String.optional

#   def to_attr_hash
#     # to_hash.reject { |key, _| %i[id owner contributors].include? key }
#     to_hash.except(:id)
#   end
# end
