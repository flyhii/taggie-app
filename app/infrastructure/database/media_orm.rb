# frozen_string_literal: true

require 'sequel'

module FlyHii
  module Database
    # Object-Relational Mapper for media Entities
    class MediaOrm < Sequel::Model(:media)
      many_to_one :hashtag_of_media,
                  class: :'FlyHii::Database::hashtagOrm',
                  key: :hashtag_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(media_info)
        first(caption: media_info[:caption]) || create(media_info)
      end
    end
  end
end
