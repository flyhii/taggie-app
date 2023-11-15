# frozen_string_literal: true

module FlyHii
  module Repository
    # Repository for Meida
    class Posts
      def self.all
        Database::MediaOrm.all.map { |db_project| rebuild_entity(db_project) }
      end

      def self.find(entity)
        find_origin_id(entity.origin_id)
      end

      def self.find_id(id)
        db_record = Database::MediaOrm.first(id:)
        rebuild_entity(db_record)
      end

      def self.find_origin_id(origin_id)
        db_record = Database::MediaOrm.first(origin_id:)
        rebuild_entity(db_record)
      end

      def self.create(entity)
        raise 'Project already exists' if find(entity)

        db_project = PersistProject.new(entity).call
        rebuild_entity(db_project)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Media.new(
          db_record.to_hash.merge(
            owner: Hashtags.rebuild_entity(db_record.owner),
            contributors: Hashtags.rebuild_many(db_record.contributors)
          )
        )
      end

      # Helper class to persist project and its members to database
      class PersistProject
        def initialize(entity)
          @entity = entity
        end

        def create_project
          Database::MediaOrm.create(@entity.to_attr_hash)
        end

        def call
          owner = Hashtags.db_find_or_create(@entity.owner)

          create_project.tap do |db_project|
            db_project.update(owner:)

            @entity.contributors.each do |contributor|
              db_project.add_contributor(Hashtags.db_find_or_create(contributor))
            end
          end
        end
      end
    end
  end
end
