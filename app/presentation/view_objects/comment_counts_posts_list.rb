# frozen_string_literal: true

module Views
    # View for a a list of commentcounts posts entities
    class RecentPostsList
      def initialize(comment_counts_posts)
        @comment_counts_posts = comment_counts_posts.map.with_index { |pos, i| CommentCountsPost.new(pos, i) }
      end
  
      def each(&show)
        show.call @comment_counts_posts
      end
  
      def any?
        @comment_counts_posts.any?
      end
  
      def posts_com
        @comment_counts_posts
      end
    end
  end
  