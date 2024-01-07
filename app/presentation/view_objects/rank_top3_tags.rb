# frozen_string_literal: true

module Views
  # View for all ranked hashtags
  class RankedList
    def initialize(top3tags, index = nil)
      @top3tags = top3tags
      @index = index
    end

    def top_3_tags
      @top3tags.ranked_hashtags
    end
  end
end
