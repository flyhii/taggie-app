# frozen_string_literal: true

module FlyHii
  # Provides access to media data
  module Instagram
    # Data Mapper: Instagram media -> Media entity
    class MediaMapper
      def initialize(ig_token, user_id, gateway_class = Instagram::Api)
        @token = ig_token
        @ig_user_id = user_id
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token, @ig_user_id)
      end

      def find(hashtag_id)
        data = @gateway.media(hashtag_id)
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data, @token, @gateway_class).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::Media.new(
            id: nil,
            caption:,
            comments_count:,
            like_count:,
            timestamp:,
            media_url:,
            children:,
            media_type:
          )
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
      end
    end
  end
end
