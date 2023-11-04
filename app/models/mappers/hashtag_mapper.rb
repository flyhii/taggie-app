# frozen_string_literal: true

module FlyHii
  # Provides access to hashtag data
  module Instagram
    # Data Mapper: Instagram contributor -> Hashtag entity
    class HashtagMapper
      def initialize(ig_token, ig_user_id, gateway_class = Instagram::Api)
        @token = ig_token
        @ig_user_id = ig_user_id
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token, @ig_user_id)
      end

      def find(hashtag_name)
        puts hashtag_name_id = @gateway.hashtag(hashtag_name)
        data = hashtag_name_id['data'][0]['id']
        build_entity(data)
      end

      def load_several(url)
        @gateway.hashtag(url).map do |data|
          HashtagMapper.build_entity(data)
        end
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::Hashtag.new(
            id:
          )
        end

        def hashtag_id
          @data['id']
        end
      end
    end
  end
end
