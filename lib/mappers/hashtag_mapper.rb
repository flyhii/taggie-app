# frozen_string_literal: true

module FlyHii
  # Provides access to hashtag data
  class Hashtag
    attr_reader :hashtag

    def initialize(hashtag_data)
      @hashtag = hashtag_data['data'][0]['id']
    end

    def hashtag_id
      @hashtag['hashtag_id']
    end

    def store_data_hashtag
      File.write('spec/fixtures/hashtag_results.yml', @hashtag.to_yaml)
      @hashtag
    end
  end
end
