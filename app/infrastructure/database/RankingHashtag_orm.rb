# frozen_string_literal: true

require 'sequel'

module FlyHii
  module Database
    # Object-Relational Mapper for RankingHashtag
    class RankingHashtagOrm < Sequel::Model(:RankingHashtag)
      many_to_many :RankingHashtag_of_media,
                   class: :'FlyHii::Database::mediaOrm',
                   join_table: :media_RankingHashtag,
                   left_key: :RankingHashtag_id, right_key: :media_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(RankingHashtag_info)
        first(caption_hashtagName: RankingHashtag_info[:caption_hashtagName]) || create(RankingHashtag_info)
      end
    end
  end
end
