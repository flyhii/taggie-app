# frozen_string_literal: true

module Views
  # View for a a list of post entities
  class PostsList
    def initialize(posts)
      # @posts = posts.map.with_index { |pos, i| Post.new(pos, i) }
      @posts = Post.new(posts, 1)
    end

    def each(&show)
      # @posts.each do |pos|
      #   show.call pos
      # end
      show.call @posts
    end

    def any?
      @posts.any?
    end
  end
end
