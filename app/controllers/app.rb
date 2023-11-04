# frozen_string_literal: true

require 'roda'
require 'slim'

module FlyHii
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :common_logger, $stderr
    plugin :halt

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        view 'home'
      end

      routing.on 'media' do
        routing.is do
          # POST /hashtag_name/
          routing.post do
            hashtag_name = routing.params['hashtag_name'].downcase
            routing.redirect "media/#{hashtag_name}"
          end
        end

        routing.on String do |hashtag_name|
          # GET /hashtag/topmedia
          routing.get do
            hashtag_id = Instagram::HashtagMapper
              .new(INSTAGRAM_TOKEN, ACCOUNT_ID)
              .find(hashtag_name)

            instagram_media = Instagram::MediaMapper
              .new(INSTAGRAM_TOKEN, ACCOUNT_ID)
              .find(hashtag_id)

            view 'media', locals: { media: instagram_media }
          end
        end
      end
    end
  end
end
