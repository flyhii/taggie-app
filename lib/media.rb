# frozen_string_literal: true

module FlyHii
  # Provides access to media data
  class Media
    attr_reader :media

    def initialize(media_data)
      @media = media_data
    end

    def id
      @media['id']
    end

    def caption
      @media['caption']
    end

    def comments_count
      @media['comments_count']
    end

    def like_count
      @media['like_count']
    end

    def timestamp
      @media['timestamp']
    end

    def media_url
      @media['media_url']
    end

    def children
      @media['children']
    end

    def media_type
      @media['media_type']
    end

    def store_data
      File.write('spec/fixtures/top_media_results.yml', @media.to_yaml, mode: 'a')
    end
  end
end
