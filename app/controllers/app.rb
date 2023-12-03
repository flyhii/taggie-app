# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

module FlyHii
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :all_verbs # allows HTTP verbs beyond GET/POST (e.g., DELETE)
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :public, root: 'app/presentation/public'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css', js: 'table_row.js'
    plugin :common_logger, $stderr

    # use Rack::MethodOverride # allows HTTP verbs beyond GET/POST (e.g., DELETE)

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'
      routing.public

      # GET /
      routing.root do
        # Get cookie viewer's previously searched hashtags
        session[:watching] ||= []
        hashtags = session[:watching]

        hashtags.none? ? flash.now[:notice] = 'Search for a Hashtag to get started' : nil

        view 'home', locals: { hashtags: }
      end

      routing.on 'media' do
        routing.is do
          # POST /hashtag_name/
          routing.post do
            hashtag_name = routing.params['hashtag_name'].downcase
            unless !hashtag_name.include?(' ') &&
                   !hashtag_name.include?('#')
              flash[:error] = 'Please enter a hashtag without spaces or #'
              response.status = 400
              routing.redirect '/'
            end

            # Get Posts from Instagram using hashtag_name
            begin
              posts = Instagram::MediaMapper
                .new(App.config.INSTAGRAM_TOKEN, App.config.ACCOUNT_ID)
                .find(hashtag_name)
            rescue StandardError => e
              App.logger.error e.backtrace.join("DB READ PROJ\n")
              flash[:error] = 'Could not find that Hashtag'
              routing.redirect '/'
            end

            # Add Posts to database
            posts.map do |post|
              Repository::For.entity(post).create(post)
            end

            # Add new hashtag to watched set in cookies
            session[:watching].insert(0, hashtag_name).uniq!

            # Redirect viewer to hashtag page
            routing.redirect "/media/#{hashtag_name}"
          end
        end

        routing.on String do |hashtag_name|
          # DELETE /hashtag/{hashtag_name}
          routing.delete do
            hashtag_name = hashtag_name.to_s
            session[:watching].delete(hashtag_name)

            routing.redirect '/'
          end

          # GET /hashtag/{hashtag_name}
          routing.get do
            path = request.remaining_path
            folder_name = path.empty? ? '' : path[1..]

            # Get post from database instead of Instagram
            begin
              posts = Repository::For.klass(Entity::Post)
                .find_(hashtag_posts)

              if posts.nil?
                flash[:error] = 'Hashtag not found'
                routing.redirect '/'
              end
            rescue StandardError
              flash[:error] = 'Having trouble accessing the database'
              routing.redirect '/'
            end

            ### TODO: Ranking in different ways
            # Rank all hashtags by counting appearances in all posts
            begin
              folder = Mapper::RankedList ### TODO: add ranker in Mapper
                .new(gitrepo).for_folder(folder_name)
            rescue StandardError
              flash[:error] = 'Could not find that folder'
              routing.redirect "/hashtag/#{folder}"
            end

            if media.empty?
              flash[:error] = 'Could not find that folder'
              routing.redirect "/hashtag/#{hashtag_name}"
            end

            # proj_folder = Views::RankedList.new(project, folder)

            # Show viewer the posts information
            view 'media', locals: { media: }

            # past media to rank repository
            # GetMedia.new(media)

            # view 'media', locals: { media: }
          end
        end
      end
    end
  end
end
