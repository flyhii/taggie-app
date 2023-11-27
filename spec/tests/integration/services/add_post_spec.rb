# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'
require_relative '../../../helpers/database_helper'

describe 'Add Post Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_instagram(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store post' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to find and save remote post to database' do
      # GIVEN: a valid url request for existing remote post:
      post = FlyHii::Instagram::MediaMapper
        .new(App.config.INSTAGRAM_TOKEN, App.config.ACCOUNT_ID)
        .find(hashtag_name)
      url_request = FlyHii::Instagram::NewPost.new.call(remote_url: IG_URL)

      # WHEN: the service is called with the request form object
      post_made = FlyHii::Service::AddPost.new.call(url_request)

      # THEN: the result should report success..
      _(post_made.success?).must_equal true

      # ..and provide a post entity with the right details
      rebuilt = post_made.value!

      _(rebuilt.origin_id).must_equal(post.origin_id)
      _(rebuilt.name).must_equal(post.name)
      _(rebuilt.size).must_equal(post.size)
      _(rebuilt.ssh_url).must_equal(post.ssh_url)
      _(rebuilt.http_url).must_equal(post.http_url)
      _(rebuilt.contributors.count).must_equal(post.contributors.count)

      post.contributors.each do |member|
        found = rebuilt.contributors.find do |potential|
          potential.origin_id == member.origin_id
        end

        _(found.username).must_equal member.username
        # won't check email as it isn't always provided
      end
    end

    it 'HAPPY: should find and return existing post in database' do
      # GIVEN: a valid url request for a post already in the database:
      url_request = FlyHii::Forms::NewPost.new.call(remote_url: IG_URL)
      db_post = FlyHii::Service::AddPost.new.call(url_request).value!

      # WHEN: the service is called with the request form object
      post_made = CodePraise::Service::AddPost.new.call(url_request)

      # THEN: the result should report success..
      _(post_made.success?).must_equal true

      # ..and find the same post that was already in the database
      rebuilt = post_made.value!
      _(rebuilt.id).must_equal(db_post.id)

      # ..and provide a post entity with the right details
      _(rebuilt.origin_id).must_equal(db_post.origin_id)
      _(rebuilt.name).must_equal(db_post.name)
      _(rebuilt.size).must_equal(db_post.size)
      _(rebuilt.ssh_url).must_equal(db_post.ssh_url)
      _(rebuilt.http_url).must_equal(db_post.http_url)
      _(rebuilt.contributors.count).must_equal(db_post.contributors.count)

      db_post.contributors.each do |member|
        found = rebuilt.contributors.find do |potential|
          potential.origin_id == member.origin_id
        end

        _(found.username).must_equal member.username
        # not checking email as it is not always provided
      end
    end

    it 'BAD: should gracefully fail for invalid post url' do
      # GIVEN: an invalid url request is formed
      bad_gh_url = 'http://facebook.com/foobar'
      url_request = CodePraise::Forms::NewPost.new.call(remote_url: bad_gh_url)

      # WHEN: the service is called with the request form object
      post_made = CodePraise::Service::AddPost.new.call(url_request)

      # THEN: the service should report failure with an error message
      _(post_made.success?).must_equal false
      _(post_made.failure.downcase).must_include 'invalid'
    end

    it 'SAD: should gracefully fail for invalid post url' do
      # GIVEN: an invalid url request is formed
      sad_gh_url = 'http://facebook.com/wfkah4389/foobarsdhkfw2'
      url_request = CodePraise::Forms::NewPost.new.call(remote_url: sad_gh_url)

      # WHEN: the service is called with the request form object
      post_made = CodePraise::Service::AddPost.new.call(url_request)

      # THEN: the service should report failure with an error message
      _(post_made.success?).must_equal false
      _(post_made.failure.downcase).must_include 'could not find'
    end
  end
end
