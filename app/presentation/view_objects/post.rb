# frozen_string_literal: true

module Views
  # View for a single hashtag entity
  class Hashtag
    def initialize(hashtag, index = nil)
      @hashtag = hashtag
      @index = index
    end

    def entity
      @hashtag
    end

    def post_link
      "/hashtag/#{hashtag_name}"
    end

    def hashtag_name
      @hashtag.hashtag_name
    end

    def index_str
      "hashtag[#{@index}]"
    end
  end
end
