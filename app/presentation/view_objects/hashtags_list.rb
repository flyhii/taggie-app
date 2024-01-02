# frozen_string_literal: true

module Views
  # View for a list of hashtag entities
  class HashtagsList
    def initialize(hashtags)
      @hashtags = hashtags.map.with_index { |hash, i| Hashtag.new(hash, i) }
    end

    def each(&show)
      @hashtags.each do |hash|
        show.call hash
      end
    end

    def any?
      @hashtags.any?
    end
  end
end
