# frozen_string_literal: true

module FlyHii
  module Repository
    # Repository for Hashtag Entities
    class Hashtags
      def self.all
        Database::HashtagOrm.all.map { |db_project| rebuild_entity(db_project) }
      end

      def self.find_api_id(api_id)
        rebuild_entity Database::HashtagOrm.first(api_id:)
      end

      def self.find_hashtag_name(hashtag_name)
        rebuild_entity Database::HashtagOrm.first(hashtag_name:)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Hashtag.new(
          api_id: db_record.api_id,
          hashtag_name: db_record.hashtag_name
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          Hashtags.rebuild_entity(db_member)
        end
      end

      def self.db_find_or_create(entity)
        Database::HashtagOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
