# frozen_string_literal: true

module FlyHii
  # Provides access to hashtag data
  module Instagram
    # Data Mapper: Instagram contributor -> Hashtag entity
    class HashtagMapper
      def initialize(ig_token, ig_user_id, gateway_class = Instagram::Api)
        @token = ig_token
        @ig_user_id = ig_user_id
        @gateway = gateway_class.new(@token, @ig_user_id)
        @data = []
      end

      def find(hashtag_name)
        @data = hashtag_name
        build_entity(@data).hashtag_name
        hashtag_name_id = @gateway.hashtag(hashtag_name)
        hashtag_name_id['data'][0]['id']
      end

      def build_entity
        DataMapper.new(@data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::Hashtag.new(
            hashtag_name:
          )
        end

        def hashtag_name
          @data
        end
      end
    end
  end
end
