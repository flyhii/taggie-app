# frozen_string_literal: true

require 'dry/transaction'

module FlyHii
  module Service
    # Transaction to store post from Instagram API to database
    class AddPost
      include Dry::Transaction

      step :get_name
      step :find_hashtag_name
      step :store_post

      private

      def get_name(input)
        if input.success?
          hashtag_name = input
          Success(hashtag_name:)
        else
          Failure("URL #{input.errors.messages.first}")
        end
      end

      def find_hashtag_name(input)
        if (post = post_in_database(input))
          input[:local_post] = post
        else
          input[:remote_post] = post_from_instagram(input)
        end
        Success(input)
      rescue StandardError => error
        Failure(error.to_s)
      end

      def store_post(input)
        post =
          if (new_po = input[:remote_post])
            Repository::For.entity(new_po).create(new_po)
          else
            input[:local_post]
          end
        Success(post)
      rescue StandardError => error
        App.logger.error error.backtrace.join("\n")
        puts 'add_post'
        Failure('Having trouble accessing the database')
      end

      # following are support methods that other services could use

      def post_from_instagram(input)
        FlyHii::Instagram::MediaMapper
          .new(App.config.INSTAGRAM_TOKEN, App.config.ACCOUNT_ID)
          .find(input)
      rescue StandardError
        raise 'Could not find that post on Instagram'
      end

      def post_in_database(input)
        Repository::For.klass(Entity::Post)
          .find_full_name(input[:owner_name], input[:project_name])
      end
    end
  end
end
