# frozen_string_literal: true

module Views
    # View for a single commentcounts post entity
    class CommentCountsPost
      def initialize(comment_counts_post, index = nil)
        @comment_counts_post = comment_counts_posts
        @index = index
      end
  
      def entity
        @comment_counts_post
      end
  
      def index_str
        "comment_counts_post[#{@index}]"
      end
  
      def content_caption
        @comment_counts_post.caption
      end
  
      def content_tags
        @comment_counts_post.tags
      end
  
      def content_comment_counts
        @comment_counts_post.comments_count
      end
  
      def content_like_count
        @comment_counts_post.like_count
      end
  
      def content_timestamp
        @comment_counts_post.timestamp
      end
  
      def content_media_url
        @comment_counts_post.media_url
      end
    end
  end
  