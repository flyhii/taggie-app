# frozen_string_literal: true

module FlyHii
  # Provides access to hashtag data
  module Instagram
    # Data Mapper: Instagram contributor -> Hashtag entity
    class HashtagMapper
      def initialize(hashtag_data, gateway_class = Github::Api)
        @hashtag = hashtag_data['data'][0]['id']
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
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

        private

        def hashtag_id
          @hashtag['hashtag_id']
        end
      end

      def store_data_hashtag
        File.write('spec/fixtures/hashtag_results.yml', @hashtag.to_yaml)
        @hashtag
      end
    end
  end
end
