# frozen_string_literal: true

require 'sequel'

module FlyHii
  module Database
    # Object Relational Mapper for hashtag Entities
    class HashtagOrm < Sequel::Model(:hashtag)
      many_to_many :media,
                    class: :'FlyHii::Database::MediaOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
