# frozen_string_literal: true

module Views
  # View for a single recent post entity
  class RecentPost
    def initialize(recent_post, index = nil)
      @recent_post = recent_post
      @index = index
    end

    def entity
      @recent_post
    end

    def index_str
      "recent_post[#{@index}]"
    end

    def content_caption
      @recent_post.caption
    end

    def content_tags
      @recent_post.tags
    end

    def content_comment_counts
      @recent_post.comments_count
    end

    def content_like_count
      @recent_post.like_count
    end

    def content_timestamp
      @recent_post.timestamp
    end

    def content_media_url
      @recent_post.media_url
    end
  end
end
