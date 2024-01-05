# frozen_string_literal: true

module Views
  # View for all ranked hashtags
  class RankedList
    def initialize(top3tags, index = nil)
      @top3tags = top3tags
      @index = index
    end

  end
end
