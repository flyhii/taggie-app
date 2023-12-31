# frozen_string_literal: true

module Views
  # View for all ranked hashtags
  class RankedList
    def initialize(hashtags, index = nil)
      @hashtags = hashtags
      @index = index
    end
  end
end
