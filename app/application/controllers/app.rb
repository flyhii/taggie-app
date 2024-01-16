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
        view 'home', locals: { search_history: }
        # view 'home', locals: {
        #   watching: result
        #  }
      end

      routing.on 'media' do
        routing.post 'translate' do
          puts 'here!'

          puts routing.params['language']
          post_translated = Service::TranslateAllPosts.new.call(routing.params['language'])
          hashtag_name = session[:watching][0]
          ranking_made = Service::RankHashtags.new.call(hashtag_name)
          puts "translated post = #{post_translated}"

          if post_translated.failure?
            flash[:error] = post_translated.failure
            routing.redirect '/'
          end

          post = Views::TranslatePostsList.new(post_translated.value!.posts)
          rank_list = Views::RankedList.new(ranking_made.value!)

          # routing.redirect '/media/translate'

          puts "Translate handled - #{request.path_info}"
          view 'media', locals: { post:, rank_list: }
        end

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

            # Only use browser caching in production
            App.configure :production do
              response.expires 60, public: true
            end

            view 'media', locals: { post:, rank_list: }
          end 
        end
      end

      routing.on 'commentcounts' do
        routing.is do
          # puts 'here!'
          # POST /media/#{hashtag_name}/translate
          routing.post do
            hashtag_name = session[:watching][0]
            #puts routing.params['language'] # rubocop:disable Layout/LeadingCommentSpace
            commentcounts_sorted = Service::SortPostByCommentCounts.new.call(hashtag_name)
            ranking_made = Service::RankHashtags.new.call(hashtag_name)
            puts "Sorted CommentCounts = #{commentcounts_sorted}"
            puts "ranking_made = #{ranking_made}"

            if commentcounts_sorted.failure?
              flash[:error] = commentcounts_sorted.failure
              routing.redirect '/'
            end

            post = Views::CommentCountsList.new(commentcounts_sorted.value!.posts)
            rank_list = Views::RankedList.new(ranking_made.value!)

            # routing.redirect '/commentcounts'

            # Only use browser caching in production
            App.configure :production do
              response.expires 60, public: true
            end

            view 'media', locals: { post:, rank_list: }

            # puts "come on"
          end
          # routing.get do
          #   puts "I'm here"

          #   view 'translate', locals: { post:, rank_list: }
          # end
        end
      end
      routing.on 'recentMedia' do
        routing.is do
          routing.post do
            puts 'recentMedia'
            puts hashtag_name = session[:watching][0]
            recent_post_made = Service::AddRecentPost.new.call(hashtag_name)

            if recent_post_made.failure?
              flash[:error] = recent_post_made.failure
              routing.redirect '/'
            end

            ranking_made = Service::RankHashtags.new.call(hashtag_name)

            if ranking_made.failure?
              flash[:error] = ranking_made.failure
              routing.redirect '/'
            end

            recent_post = Views::PostsList.new(recent_post_made.value!.posts)
            rank_list = Views::RankedList.new(ranking_made.value!)

            view 'media', locals: { recent_post:, rank_list: }
          end
        end
      end
    end
  end
end
