# frozen_string_literal: true

module Views
  # View for a single post entity
  class Post
    def initialize(post, index = nil)
      @post = post
      @index = index
    end

    def entity
      @post
    end

    # #ask the route, need to revise (also based on domain ?)
    # def post_link
    #   "/hashtag/#{hashtag_name}"
    # end

    # def hashtag_name
    # end

    def index_str
      "post[#{@index}]"
    end

    def content_caption
      @post.caption
    end

    def content_tags
      @post.tags
    end

    def content_comment_counts
      @post.comments_count
    end

    def content_like_count
      @post.like_count
    end

    def content_timestamp
      @post.timestamp
    end

    def content_media_url
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
