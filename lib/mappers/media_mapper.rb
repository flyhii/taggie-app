# frozen_string_literal: true

require_relative 'hashtag_mapper'

module FlyHii
  # Provides access to media data
  module Instagram
    class MediaMapper
      def initialize(token, user_id, gateway_class = Github::Api)
        @token = ig_token
        @ig_user_id = user_id
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def find(hashtag_id)
        data = @gateway.media(hashtag_id)
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data, @token, @gateway_class).build_entity
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
end
  