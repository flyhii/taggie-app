# frozen_string_literal: true

require 'dry/transaction'

module FlyHii
  module Service
    # Transaction to store project from Github API to database
    class AddPost
      include Dry::Transaction

      step :validate_input
      step :request_post
      step :reify_post

      private

      def get_name(input)
        puts '0'
        if input.success?
          puts '1'
          hashtag_name = input
          Success(hashtag_name:)
        else
          Failure(input.errors.messages)
        end
      end

      def find_hashtag_name(input)
        # if (post = post_in_database(input))
        #   input[:local_post] = post
        # else
        #   puts input
        puts '2'
        input[:remote_post] = post_from_instagram(input)
        # end
        Success(input)
      rescue StandardError => error
        Failure(error.to_s)
      end

      def store_post(input)
        puts '3'
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
        hashtag_name = input[:hashtag_name][:hashtag_name]
        puts "hashtag_name = #{hashtag_name}"
        FlyHii::Instagram::MediaMapper
          .new(App.config.INSTAGRAM_TOKEN, App.config.ACCOUNT_ID)
          .find(hashtag_name)
      rescue StandardError
        raise 'Could not find posts associated with this hashtag on Instagram'
      end

      def post_in_database(input)
        Repository::For.klass(Entity::Post)
          .find_hashtag_name(input[:hashtag_name])
      end
    end
  end
end
