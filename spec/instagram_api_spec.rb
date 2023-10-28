# frozen_string_literal: true

require 'minitest/unit'
require 'minitest/autorun'
require 'minitest/rg'
require_relative 'spec_helper'

describe 'Tests Instagram API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<INSTAGRAM_TOKEN>') { INSTAGRAM_TOKEN }
    c.filter_sensitive_data('<INSTAGRAM_TOKEN_ESC>') { CGI.escape(INSTAGRAM_TOKEN) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Media information' do
    it 'HAPPY: should provide correct media information' do
      media = FlyHii::InstagramApi.new(INSTAGRAM_TOKEN, ACCOUNT_ID)
                                      .media(HASHTAG_ID)
      _(media.id).must_equal CORRECT['id']
      _(media.caption).must_equal CORRECT['caption']
      _(media.comments_count).must_equal CORRECT['comments_count']
      _(media.like_count).must_equal CORRECT['like_count']
      _(media.timestamp).must_equal CORRECT['timestamp']
    end

    it 'SAD: should raise exception on media information' do
      _(info do
        FlyHii::InstagramApi.new(INSTAGRAM_TOKEN, ACCOUNT_ID).media('wronghashtagID')
      end).must_raise FlyHii::InstagramApi::Response::NotFound
    end

    it 'SAD: should raise exception when unauthorized' do
      _(info do
        FlyHii::InstagramApi.new('BAD_TOKEN', 'BAD_ACCOUNT_ID').media('wronghashtagID')
      end).must_raise FlyHii::InstagramApi::Response::Unauthorized
    end
  end

  describe 'Hashtag information' do
    before do
      @media = FlyHii::InstagramApi.new(INSTAGRAM_TOKEN, ACCOUNT_ID)
                                      .media(HASHTAG_ID)
    end

    it 'HAPPY: should recognize hashtag' do
      _(@hashtag).must_equal CORRECT_HS
    end
  end
end
