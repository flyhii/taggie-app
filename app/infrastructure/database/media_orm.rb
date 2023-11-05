# frozen_string_literal: true

require 'sequel'

module FlyHii
  module Database
    # Object-Relational Mapper for media Entities
    class RankingHashtagOrm < Sequel::Model(:RankingHashtag)
      many_to_one :hashtag_of_media,
                  class: :'FlyHii::Database::hashtagOrm',
                  key: :hashtag_id

      many_to_many :RankingHashtag,
                   class: :'CodePraise::Database::RankingHashtagOrm',
                   join_table: :media_RankingHashtag,
                   left_key: :member_id, right_key: :RankingHashtag_id

      plugin :timestamps, update_on_create: true
    end
  end
end

