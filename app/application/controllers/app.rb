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

        result = session[:watching]
        puts result

        # if result.failure?
        #   flash[:error] = result.failure
        #   viewable_hashtags = []
        # else
        #   hashtags = result.value!.hashtags
        #   flash.now[:notice] = MSG_GET_STARTED if hashtags.none?

        # session[:watching] = hashtags.map(&:fullname)
        # viewable_hashtags = Views::HashtagsList.new(result)
        # end
        search_history = Views::HistoryViewObject.new(result)
        view 'home', locals: { search_history: search_history }
        # view 'home', locals: {
        #   watching: result
        #  }
      end

      routing.on 'media' do
        routing.is do
          # POST /media/
          routing.post do
            hashtag_name = Forms::HashtagName.new.call(routing.params)
            puts "hashtagname = #{hashtag_name['hashtag_name']}"
            post_made = Service::AddPost.new.call(hashtag_name)

            # if the process of hashtag lead to increase the post has some wrong, lead to home page
            if post_made.failure?
              flash[:error] = post_made.failure
              routing.redirect '/'
            end

            puts "post_made = #{post_made.value!}"
            session[:watching].insert(0, hashtag_name['hashtag_name']).uniq!
            flash[:notice] = MSG_POST_ADDED

            # # get recent posts
            # recent_post_made = Service::AddRecentPost.new.call(hashtag_name)
            # if recent_post_made.failure?
            #   flash[:error] = recent_post_made.failure
            #   routing.redirect '/'
            # end

            # puts "recent_post_made = #{recent_post_made.value!}"

            # routing.redirect "media/#{@hashtag_name['hashtag_name']}"
            ranking_made = Service::RankHashtags.new.call(hashtag_name['hashtag_name'])
            puts "ranking_made = #{ranking_made}"

            if ranking_made.failure?
              flash[:error] = ranking_made.failure
              routing.redirect '/'
            end

            # routing.redirect "media/#{hashtag_name['hashtag_name']}"

            post = Views::PostsList.new(post_made.value!.posts)
            rank_list = Views::RankedList.new(ranking_made.value!)
            # binding.irb
            puts rank_list.top_3_tags
            view 'media', locals: { post:, rank_list: }
          end
        end
      
        routing.on 'translate' do
          routing.is do
            # puts 'here!'
            # GET /media/#{hashtag_name}/ranking
            routing.post do
              # puts routing.params['language']
              post_made = Service::TranslateAllPosts.new.call(routing.params['language'])
              ranking_made = Service::RankHashtags.new.call(hashtag_name['hashtag_name'])
              # puts "ranking_made = #{ranking_made}"

              if ranking_made.failure?
                flash[:error] = ranking_made.failure
                routing.redirect '/'
              end

              posts_list = Views::TranslatePostsList.new(post_made.value!.posts)
              rank_list = Views::RankedList.new(ranking_made.value!)

              view 'media', locals: { posts_list:, rank_list: }
            end    
          end
        end  

        routing.on String do |hashtag_name|
          puts 'here!'
          # DELETE /media/#{hashtag_name} delete previous history
          routing.delete do
            fullname = hashtag_name
            session[:watching].delete(fullname)

            routing.redirect '/'
          end

          # GET /media/#{hashtag_name}/ranking
          routing.get do
            ranking_made = Service::RankHashtags.new.call(hashtag_name)
            puts "ranking_made = #{ranking_made}"
            # if the process of hashtag lead to increase the post has some wrong, lead to home page
            if ranking_made.failure?
              flash[:error] = ranking_made.failure
              routing.redirect '/'
            end
            @post_made = session[:post_made]
            puts "post_made = #{@post_made}"
            posts_list = Views::PostsList.new(@post_made.value!)
            rank_list = Views::RankedList.new(ranking_made.value!)

            view 'media', locals: { posts_list:, rank_list: }

            # Only use browser caching in production
            App.configure :production do
              response.expires 60, public: true
            end
          end
        end
      end
    end
  end
end
