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
        puts result
        if result.failure?
          puts 'fail'
          flash[:error] = result.failure
          viewable_hashtags = []
        else
          hashtags = result.value!.hashtags
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
            #must be input hashtag, but there is some wrong now
            hashtag_name = Forms::HashtagName.new.call(routing.params)
            post_made = Service::AddPost.new.call(hashtag_name)

            #if the process of hashtag lead to increase the post has some wrong, lead to home page
            if post_made.failure?
              flash[:error] = post_made.failure
              routing.redirect '/'
            end

            post = post_made.value! #
            session[:watching].insert(0, post.fullname).uniq! #第二次之後存cookie
            flash[:notice] = MSG_POST_ADDED
            routing.redirect "media/#{hashtag_name}"
          end
        end

        routing.on String, String do |hashtag_name|
          # DELETE /media/#{hashtag_name} delete previous history
          routing.delete do
            fullname = hashtag_name
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

            posts_list = Views::PostsList.new(post_made)
            #rank_list = Views::RankedList.new(ranking_made)  # turning to rank things

            view 'media', locals: { posts_list: , rank_list: }

            
          end
        end
      end
    end
  end
end
