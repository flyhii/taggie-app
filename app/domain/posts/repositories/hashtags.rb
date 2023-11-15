# frozen_string_literal: true

module FlyHii
  module Repository
    # Repository for Hashtag Entities
    class Hashtags
      def self.all
        Database::HashtagOrm.all.map { |db_hashtag| rebuild_entity(db_hashtag) }
      end

      #   def self.find_full_name(owner_name, project_name)
      #     # SELECT * FROM `projects` LEFT JOIN `members`
      #     # ON (`members`.`id` = `projects`.`owner_id`)
      #     # WHERE ((`username` = 'owner_name') AND (`name` = 'project_name'))
      #     db_project = Database::ProjectOrm
      #       .left_join(:members, id: :owner_id)
      #       .where(username: owner_name, name: project_name)
      #       .first
      #     rebuild_entity(db_project)
      #   end

      def self.find(entity)
        find_origin_id(entity.origin_id)
      end

      def self.find_id(api_id)
        db_record = Database::HashtagOrm.first(api_id:)
        rebuild_entity(db_record)
      end

      def self.find_name(hashtag_name)
        db_record = Database::HashtagOrm.first(hashtag_name:)
        rebuild_entity(db_record)
      end

      def self.find_origin_id(origin_id)
        db_record = Database::HashtagOrm.first(origin_id:)
        rebuild_entity(db_record)
      end

      def self.create(entity)
        raise 'Hashtag already exists' if find(entity)

        db_hashtag = PersistProject.new(entity).call
        rebuild_entity(db_hashtag)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Hashtag.new(
          db_record.to_hash.merge(
            owner: Members.rebuild_entity(db_record.owner),
            contributors: Members.rebuild_many(db_record.contributors)
          )
        )
      end

      # Helper class to persist project and its members to database
      class PersistProject
        def initialize(entity)
          @entity = entity
        end

        def create_hashtag
          Database::HashtagOrm.create(@entity.to_attr_hash)
        end

        # def call
        #   owner = Members.db_find_or_create(@entity.owner)

        #   create_hashtag.tap do |db_hashtag|
        #     db_hashtag.update(owner:)

        #     @entity.contributors.each do |contributor|
        #       db_hashtag.add_contributor(Members.db_find_or_create(contributor))
        #     end
        #   end
        # end
      end
    end
  end
end
