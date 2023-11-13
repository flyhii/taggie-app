# FlyHii

Application that allow client to use interesting hashtag searching top 50 post.

## Overview

FlyHii will pull data from Instagram's API.

## Objectives

### Short-term usability goals

### Long-term goals

## Entities

These are objects that are important to the post inquiry system, following our team's naming conventions:

- Account (all the information about personal user account)
- Post (Be post by account)

## Setup

- Create a personal Instagram API access token in https://developers.facebook.com/docs/instagram-basic-display-api
- Copy `config/secrets_example.yml` to `config/secrets.yml` and update token
- Ensure correct version of Ruby install (see `.ruby-version` for `rbenv`)
- Run `bundle install`
- Run `bundle exec rake db:migrate` to create dev database
- Run `RACK_ENV=test bundle exec rake db:migrate` to create test database

## Running tests

To run tests:

```shell
rake spec
```
