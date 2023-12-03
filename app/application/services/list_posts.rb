# frozen_string_literal: true

require 'dry/monads'

module FlyHii
  module Service
    # Retrieves array of all listed posts entities
    class ListPosts
      include Dry::Monads::Result::Mixin

      def call(posts_list)
        posts = Repository::For.klass(Entity::Post)
          .find_full_names(posts_list)

        Success(posts)
      rescue StandardError
        Failure('Could not access database')
      end
    end
  end
end
