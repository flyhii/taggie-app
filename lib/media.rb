# frozen_string_literal: true

module FlyHii
  # Provides access to media data
  # media抓過去owner那邊的項目(Project => Contributor)
  class Media
    attr_reader :media

    def initialize(media_data)
      @media = media_data
      # puts media_data
      # if media_data && media_data['data'] && !media_data['data'].empty?
      #   @media = media_data
      # else
      #   puts "nil"
      # end
      
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

    def store_data
      File.write('spec/fixtures/top_media_results.yml', @media.to_yaml, mode: 'a')
    end
  end
end
