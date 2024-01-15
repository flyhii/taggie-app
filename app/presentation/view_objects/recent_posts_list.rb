# frozen_string_literal: true

module Views
  # View for a a list of post entities
  class RecentPostsList
    def initialize(recent_posts)
      @recent_posts = recent_posts.map.with_index { |pos, i| RecentPost.new(pos, i) }
      # @posts = Post.new(posts, 1)
    end

    def each(&show)
      # @posts.each do |pos|
      #   show.call pos
      # end
      show.call @recent_posts
    end

    def any?
      @recent_posts.any?
    end

    def posts_re
      @recent_posts
    end
  end
end
