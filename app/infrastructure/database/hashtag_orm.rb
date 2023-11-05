# frozen_string_literal: true

require 'sequel'

module FlyHii
  module Database
    # Object Relational Mapper for hashtag Entities
    class hashtagOrm < Sequel::Model(:hashtag)
      one_to_many :media,
                  class: :'FlyHii::Database::mediaOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
