# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'helpers/vcr_helper'

describe 'Tests Instagram API library' do
  before do
    VcrHelper.configure_vcr_for_instagram
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Media information' do
    before do
      @media_info = FlyHii::Instagram::MediaMapper
        .new(INSTAGRAM_TOKEN, ACCOUNT_ID)
        .find(HASHTAG_ID)
    end

    # wait for revise

    it 'HAPPY: should provide correct media attributes' do
      media_info =
        FlyHii::Instagram::MediaMapper
          .new(INSTAGRAM_TOKEN, ACCOUNT_ID)
          .find(HASHTAG_ID)
      _(media_info.id).must_equal CORRECT['id']
      _(media_info.caption).must_equal CORRECT['caption']
      _(media_info.comments_count).must_equal CORRECT['comments_count']
      _(media_info.like_count).must_equal CORRECT['like_count']
      _(media_info.timestamp).must_equal CORRECT['timestamp']
      _(media_info.media_url).must_equal CORRECT['media_url']
      _(media_info.children).must_equal CORRECT['children']
      _(media_info.media_type).must_equal CORRECT['media_type']
    end

    it 'BAD: should raise exception on incorrect project' do
      _(proc do
        FlyHii::Instagram::MediaMapper
          .new(INSTAGRAM_TOKEN, ACCOUNT_ID)
          .find('fake_hashtag_name')
      end).must_raise FlyHii::Instagram::Api::Response::NotFound
    end

    it 'BAD: should raise exception when unauthorized' do
      _(proc do
        FlyHii::Instagram::MediaMapper
          .new('BAD_TOKEN', ACCOUNT_ID)
          .find(HASHTAG_ID)
      end).must_raise FlyHii::Instagram::Api::Response::Unauthorized
    end
  end
end
