# frozen_string_literal: true

module FlyHii
  # Provides access to contributor data
  class Hashtag
    attr_reader :hashtag

    def initialize(hashtag_data)
      @hashtag = hashtag_data['data'][0]['id']
    end
  end
end
