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
        hashtag_name_id = @gateway.hashtag(hashtag_name)
        hashtag_name_id['data'][0]['id']
      end
    end
  end
end
