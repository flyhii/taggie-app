# frozen_string_literal: true

require 'roda'
require 'slim'

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

    use Rack::MethodOverride # allows HTTP verbs beyond GET/POST (e.g., DELETE)

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'
      routing.public

      # GET /
      routing.root do
        hashtag = Repository::For.klass(Entity::Hashtag).all
        view 'home', locals: { hashtag: }
      end

      routing.on 'media' do
        routing.is do
          # POST /hashtag_name/
          routing.post do
            hashtag_name = routing.params['hashtag_name'].downcase

            # Get hashtag id from Instagram
            hashtag = Instagram::HashtagMapper
              .new(App.config.INSTAGRAM_TOKEN, App.config.ACCOUNT_ID)
              .find(hashtag_name)
            puts hashtag

            # Get media from Instagram
            puts hashtag.api_id
            instagram_media = Instagram::MediaMapper
              .new(App.config.INSTAGRAM_TOKEN, App.config.ACCOUNT_ID)
              .find(hashtag.api_id)

            # Add hashtag to database
            Repository::For.entity(hashtag).create(hashtag)

            # Add media to database
            Repository::For.entity(instagram_media).create(instagram_media)

            routing.redirect "media/#{hashtag_name}"
          end
        end

        routing.on String do |hashtag_name|
          # GET /hashtag/topmedia
          routing.get do
            # Get media from database
            media = Repository::For.klass(Entity::Media)
              .find_media(hashtag_name)

            # past media to rank repository
            GetMedia.new(media)

            view 'media', locals: { media: }
          end
        end
      end
    end
  end
end
