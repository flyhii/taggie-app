# FlyHii

Application that allow client to use interesting hashtag searching top 50 post, and also guide the users to the top3 related hashtag that they may be interesting. There will have three more sorting methods, using like counts, comments counts, and timestamp to sort the posts.

## Overview

FlyHii will pull data from Instagram's API, as well as analyze the hashtags, timestamp, like counts, comments counts information.

When users search the hashtag that they are interesting, it will then generate *top50 popular posts*, and also *hashtag ranking* that users may be interesting in, and also shows multiple sorting methods using like counts, comments counts, and timestamp that may meet users needs. In addition, we offer multiple hashtags searching way, such as searching hashtags of "new + start" that may be more in line with user needs. Users should feel convenient to find their interesting hashtags and posts.
We hope this tool will give users a clear and diverse way to use hashtag searching to reach the post contents and more related hashtags that they might be interesting in. 

## Objectives

### Short-term usability goals

- Pull data from Instagram API, dig into top_media and hashtags
- Analyze posts data to generate hashtags ranking and retrieve like counts, comments counts, and timestamp. 
- Display the filter of like counts, comments counts, and timestamp, and the top3 relatd hashtags that can guide to each of their top50 posts.
- Hashtag (some label in the posts)
- Post (the media contents on Instagram)


### Long-term goals

<!-- - haven't think about this one -->

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
