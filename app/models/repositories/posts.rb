# frozen_string_literal: true

module FlyHii
    module Repository
      # Repository for Meida
      class Posts
        def self.find_id(id)
          rebuild_entity Database::MemberOrm.first(id:)
        end
  
        def self.find_username(username)
          rebuild_entity Database::MemberOrm.first(username:)
        end
  
        def self.rebuild_entity(db_record)
          return nil unless db_record
  
          Entity::Media.new(
            id: db_record.id,
            origin_id: db_record.origin_id,
            username: db_record.username,
            email: db_record.email
          )
        end
  
        #ok ?
        #if you create array of database records => map through thrm and create an array of posts for you of posts entites for you
        def self.rebuild_many(db_records)
          db_records.map do |db_post|
            Posts.rebuild_entity(db_post)
          end
        end
  
        def self.db_find_or_create(entity)
          Database::MemberOrm.find_or_create(entity.to_attr_hash)
        end
      end
    end
  end
