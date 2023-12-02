# frozen_string_literal: true

require 'dry/transaction'

module FlyHii
  module Service
    # Transaction to store project from Github API to database
    class AddPost
      include Dry::Transaction

      step :get_name
      step :find_project
      step :store_project

      private

      def get_name(input)
        if input.success?
          hashtag_name = input
          Success(hashtag_name:)
        else
          Failure("URL #{input.errors.messages.first}")
        end
      end

      def find_hashtag(input)
        if (project = project_in_database(input))
          input[:local_project] = project
        else
          input[:remote_project] = project_from_github(input)
        end
        Success(input)
      rescue StandardError => error
        Failure(error.to_s)
      end

      def store_post(input)
        post =
          if (new_proj = input[:remote_post])
            Repository::For.entity(new_proj).create(new_proj)
          else
            input[:local_post]
          end
        Success(post)
      rescue StandardError => error
        App.logger.error error.backtrace.join("\n")
        Failure('Having trouble accessing the database')
      end

      # following are support methods that other services could use

      def project_from_github(input)
        FlyHii::Instagram::MediaMapper
          .new(App.config.INSTAGRAM_TOKEN, App.config.ACCOUNT_ID)
          .find(input)
      rescue StandardError
        raise 'Could not find that post on Github'
      end

      def post_in_database(input)
        Repository::For.klass(Entity::Post)
          .find_full_name(input[:owner_name], input[:project_name])
      end
    end
  end
end
