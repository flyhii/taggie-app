# frozen_string_literal: true

require 'dry/transaction'

module FlyHii
  module Service
    # Analyzes ranking to a post
    class AppraisePost
      include Dry::Transaction

      step :ensure_watched_post
      step :retrieve_remote_post
      step :clone_remote
      step :appraise_ranking

      private

      # Steps

      def ensure_watched_post(input)
        if input[:watched_list].include? input[:requested].post_fullname
          Success(input)
        else
          Failure('Please first request this post to be added to your list')
        end
      end

      def retrieve_remote_post(input)
        input[:post] = Repository::For.klass(Entity::Post).find_full_name(
          input[:requested].owner_name, input[:requested].post_name
        )

        input[:post] ? Success(input) : Failure('Project not found')
      rescue StandardError
        Failure('Having trouble accessing the database')
      end

      # can skip
      def clone_remote(input)
        gitrepo = GitRepo.new(input[:post])
        gitrepo.clone! unless gitrepo.exists_locally?

        Success(input.merge(gitrepo:))
      rescue StandardError
        App.logger.error error.backtrace.join("\n")
        Failure('Could not clone this project')
      end

      def appraise_ranking(input)
        input[:folder] = Mapper::Contributions
          .new(input[:gitrepo]).for_folder(input[:requested].folder_name)

        Success(input)
      rescue StandardError
        App.logger.error "Could not find: #{full_request_path(input)}"
        Failure('Could not find that folder')
      end

      # Helper methods

      def full_request_path(input)
        [input[:requested].owner_name,
         input[:requested].project_name,
         input[:requested].folder_name].join('/')
      end
    end
  end
end
