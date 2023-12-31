# frozen_string_literal: true

require_relative '../../helpers/spec_helper'

describe 'Unit test of FlyHii API gateway' do
  it 'must report alive status' do
    alive = FlyHii::Gateway::Api.new(FlyHii::App.config).alive?
    _(alive).must_equal true
  end

  it 'must be able to add new hashtag' do
    res = FlyHii::Gateway::Api.new(FlyHii::App.config)
      .add_project(USERNAME, PROJECT_NAME)

    _(res.success?).must_equal true
    _(res.parse.keys.count).must_be :>=, 5
  end

  it 'must return a list of posts' do
    # GIVEN a post is in the database
    FlyHii::Gateway::Api.new(FlyHii::App.config)
      .add_project(USERNAME, PROJECT_NAME)

    # WHEN we request a list of posts
    list = [[USERNAME, PROJECT_NAME].join('/')]
    res = FlyHii::Gateway::Api.new(FlyHii::App.config)
      .projects_list(list)

    # THEN we should see a single post in the list
    _(res.success?).must_equal true
    data = res.parse
    _(data.keys).must_include 'projects'
    _(data['projects'].count).must_equal 1
    _(data['projects'].first.keys.count).must_be :>=, 5
  end

  it 'must return a post appraisal' do
    # GIVEN a project is in the database
    FlyHii::Gateway::Api.new(FlyHii::App.config)
      .add_project(USERNAME, PROJECT_NAME)

    # WHEN we request an appraisal
    req = OpenStruct.new(
      project_fullname: USERNAME + '/' + PROJECT_NAME,
      owner_name: USERNAME,
      project_name: PROJECT_NAME,
      foldername: ''
    )

    res = FlyHii::Gateway::Api.new(FlyHii::App.config)
      .appraise(req)

    # THEN we should see a single post in the list
    _(res.success?).must_equal true
    data = res.parse
    _(data.keys).must_include 'project'
    _(data.keys).must_include 'folder'
  end
end
