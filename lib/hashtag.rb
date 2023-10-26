# frozen_string_literal: true

module FlyHii
  # Provides access to hashtag data
  class Hashtag
    attr_reader :hashtag

    def initialize(hashtag_data)
      # if hashtag_data && hashtag_data['data'] && !hashtag_data['data'].empty?
      #   @hashtag = hashtag_data['data'][0]['id']
      # else
      #   puts "nil"
      # end
      @hashtag = hashtag_data['data'][0]['id']
    end

    def hashtag_id  #why要有這個?
      @hashtag['hashtag_id']
    end

    def store_data_hashtag
      File.write('spec/fixtures/hashtag_results.yml', @hashtag.to_yaml)
      return @hashtag
    end
  end
end
