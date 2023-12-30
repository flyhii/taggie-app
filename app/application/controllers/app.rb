# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require_relative 'helpers'

module FlyHii
  # Web App
  class App < Roda
    include RouteHelpers

    plugin :halt
    plugin :flash
    plugin :all_verbs # allows DELETE and other HTTP verbs beyond GET/POST
    plugin :caching
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', js: 'table_row.js'
    plugin :common_logger, $stderr

    use Rack::MethodOverride

    MSG_GET_STARTED = 'Search for a Hashtag to get started'
    MSG_POST_ADDED = 'Post added to your list'

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'
      routing.public

      # GET /
      routing.root do
        # Get cookie viewer's previously seen hashtags
        session[:watching] ||= []

        result = Service::ListHashtags.new.call(session[:watching])
        if result.failure?
          puts "fail"
          flash[:error] = result.failure
          viewable_hashtags = []
        else
          hashtags = result.value!.hashtags
          puts hashtags
          flash.now[:notice] = MSG_GET_STARTED if hashtags.none?

          session[:watching] = hashtags.map(&:fullname)
          viewable_hashtags = Views::HashtagsList.new(hashtags)
        end

        view 'home', locals: { hashtags: viewable_hashtags }
      end

      routing.on 'media' do
        routing.is do
          # POST /media/
          routing.post do
            puts routing.params['hashtag_name']
            hashtag_name = Forms::HashtagName.new.call(routing.params['hashtag_name'])
            puts "hashtagname = #{hashtag_name}"
            post_made = Service::AddPost.new.call(hashtag_name)

            if post_made.failure?
              flash[:error] = post_made.failure
              routing.redirect '/'
            end

            post = post_made.value!
            session[:watching].insert(0, post.fullname).uniq!
            flash[:notice] = MSG_POST_ADDED
            routing.redirect "media/#{hashtag_name}"
          end
        end

        routing.on String, String do |hashtag_name|
          # DELETE /media/#{hashtag_name}
          routing.delete do
            fullname = "#{hashtag_name}"
            session[:watching].delete(fullname)

            routing.redirect '/'
          end

          # GET /media/#{hashtag_name}/ranking
          routing.get do
            path_request = PostRequestPath.new(
              post_name, request
            )

            session[:watching] ||= []

            result = Service::AppraisePost.new.call(
              watched_list: session[:watching],
              requested: path_request
            )

            if result.failure?
              flash[:error] = result.failure
              routing.redirect '/'
            end

            appraised = result.value!
            post_folder = Views::ProjectFolderContributions.new(
              appraised[:media], appraised[:folder]
            )

            # Only use browser caching in production
            App.configure :production do
              response.expires 60, public: true
            end

            view 'media', locals: { post_folder: }
          end
        end
      end
    end
  end
end
