# frozen_string_literal: true

module FlyHii
  # Provides access to media data
  module Instagram
    # Data Mapper: Instagram media -> Media entity
    class MediaMapper
      def initialize(ig_token, user_id, gateway_class = Instagram::Api)
        @token = ig_token
        @ig_user_id = user_id
        @gateway = gateway_class.new(@token, @ig_user_id)
        @data = []
      end

      def find(hashtag_id)
        media_content = @gateway.media(hashtag_id)
        # data = media_content['data'][0]
        # puts one_media = build_entity(data)
        # one_media
        @data = media_content['data']
        build_entity
      end

      def build_entity
        @data.map do |post|
          DataMapper.new(post).build_entity
        end
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::Media.new(
            id:,
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
          @data['id']
        end

        def caption
          @data['caption']
        end

        def comments_count
          @data['comments_count']
        end

        def like_count
          @data['like_count']
        end

        def timestamp
          @data['timestamp']
        end

        def media_url
          @data['media_url']
        end

        def children
          @data['children']
        end

        def media_type
          @data['media_type']
        end
      end
    end
  end
end
