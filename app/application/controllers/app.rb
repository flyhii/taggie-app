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
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', js: 'table_row.js'
    plugin :common_logger, $stderr

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

        result = Service::ListPosts.new.call(session[:watching])

        if result.failure?
          flash[:error] = result.failure
          viewable_posts = []
        else
          posts = result.value!
          flash.now[:notice] = MSG_GET_STARTED if posts.none?

          session[:watching] = posts.map(&:fullname)
          viewable_posts = Views::PostsList.new(posts)
        end

        view 'home', locals: { post: viewable_posts }
      end

      routing.on 'post' do
        routing.is do
          # POST /post/
          routing.post do
            url_request = Forms::NewPost.new.call(routing.params)
            post_made = Service::AddPost.new.call(url_request)

            if post_made.failure?
              flash[:error] = post_made.failure
              routing.redirect '/'
            end

            post = post_made.value!
            session[:watching].insert(0, post.fullname).uniq!
            flash[:notice] = MSG_POST_ADDED
            routing.redirect "project/#{post.owner.username}/#{post.name}"
          end
        end

        # can skip?
        routing.on String, String do |owner_name, project_name|
          # DELETE /post/{owner_name}/{project_name}
          routing.delete do
            fullname = "#{owner_name}/#{project_name}"
            session[:watching].delete(fullname)

            routing.redirect '/'
          end

          # GET /project/{owner_name}/{project_name}[/folder_namepath/]
          routing.get do
            path_request = PostRequestPath.new(
              owner_name, project_name, request
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
              appraised[:post], appraised[:folder]
            )

            view 'post', locals: { post_folder: }
          end
        end
      end
    end
  end
end
