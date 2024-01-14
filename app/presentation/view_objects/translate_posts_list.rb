# frozen_string_literal: true

module Views
    # View for a a list of post entities
    class TranslatePostsList
      def initialize(posts)
        @posts = posts.map.with_index { |pos, i| TranslatePost.new(pos, i) }
        # @posts = Post.new(posts, 1)
      end
  
      def each(&show)
        @posts.each do |pos|
          show.call pos
        end
      end
  
      def any?
        @posts.any?
      end
  
      def posts_ca
        @posts
      end
    end
  end
  