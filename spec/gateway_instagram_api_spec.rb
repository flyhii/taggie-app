# frozen_string_literal: true

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

  describe 'Media information' do
    before do
      @project = FlyHii::Instagram::MediaMapper
        .new(INSTAGRAM_TOKEN, ACCOUNT_ID)
        .find(HASHTAG_ID)
    end

    it 'HAPPY: should recognize owner' do
      _(@project.owner).must_be_kind_of FlyHii::Entity::Member
    end

    it 'HAPPY: should identify owner' do
      _(@project.owner.username).wont_be_nil
      _(@project.owner.username).must_equal CORRECT['owner']['login']
    end

    it 'HAPPY: should identify members' do
      members = @project.members
      _(members.count).must_equal CORRECT['contributors'].count

      usernames = members.map(&:username)
      correct_usernames = CORRECT['contributors'].map { |c| c['login'] }
      _(usernames).must_equal correct_usernames
    end
  end
end
