# Instagram API client

Project to gather account and post information from Instagram API

## Resources

- User name
- User Account Information
- Post Count
- Post Content

## Elements

- User Information
  - list personal user information
  - list user status
- Post Information
  - id
  - post content

## Entities

These are objects that are important to the post inquiry system, following our team's naming conventions:

- Account (all the information about personal user account)
- Post (Be post by account)

## Install

## Setting up this script

- Create a personal Instagram API access token in https://developers.facebook.com/docs/instagram-basic-display-api
- Copy `config/secrets_example.yml` to `config/secrets.yml` and update token
- Ensure correct version of Ruby install (see `.ruby-version` for `rbenv`)
- Run `bundle install`

## Running this script

To create fixtures, run:

```shell
ruby lib/account_info.rb
```

Fixture data should appear in `spec/fixtures/` folder