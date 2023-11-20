# frozen_string_literal: true

module FlyHii
  module Repository
    # Repository for Meida
    class Posts
      def self.all
        Database::MediaOrm.all.map { |db_post| rebuild_entity(db_post) }
      end

      def self.find(entity)
        find_remote_id(entity.remote_id)
      end

      # def self.find_id(id)
      #   db_record = Database::MediaOrm.first(id:)
      #   rebuild_entity(db_record)
      # end

      def self.find_remote_id(remote_id)
        db_record = Database::MediaOrm.first(remote_id:)
        rebuild_entity(db_record)
      end

      def self.create(entity)
        raise 'Post already exists' if find(entity)

        db_post = PersistPost.new(entity).call ### TODO: Do we need this?
        rebuild_entity(db_post)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        ### TODO: change to Entity::Post
        Entity::Post.new(
          db_record.to_hash.merge(
            owner: Hashtags.rebuild_entity(db_record.owner),
            contributors: Hashtags.rebuild_many(db_record.contributors)
          )
        )
      end

      # Helper class to persist post to database
      class PersistPost
        def initialize(entity)
          @entity = entity
        end

        def create_post
          Database::MediaOrm.create(@entity.to_attr_hash)
        end

        def call
          owner = Hashtags.db_find_or_create(@entity.owner)

          create_post.tap do |db_post|
            db_post.update(owner:)

            @entity.contributors.each do |contributor|
              db_post.add_contributor(Hashtags.db_find_or_create(contributor))
            end
          end
        end
      end
    end
  end
end
