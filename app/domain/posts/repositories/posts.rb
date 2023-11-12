# frozen_string_literal: true

module FlyHii
  module Repository
    # Repository for Meida
    class Posts
      def self.find_id(id)
        rebuild_entity Database::MediaOrm.first(id:)
      end

      def self.find_caption(caption)
        rebuild_entity Database::MediaOrm.first(caption:)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Media.new(
          id: db_record.id,
          # origin_id: db_record.origin_id,
          caption: db_record.caption,
          like_count: db_record.like_count,
          comments_count: db_record.comments_count,
          media_url: db_record.media_url,
          timestamp: db_record.timestamp
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_post|
          Posts.rebuild_entity(db_post)
        end
      end

      def self.db_find_or_create(entity)
        Database::MediaOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
