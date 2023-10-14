# Amadeus API client

Project to gather flight information from Amadeus API (v1)

## Resources

- Departure
- Arrival
- Price

## Elements

- Flight Information
  - list all the flight
  - list flight price
- Airline
  - name
  - flight number

## Entities

These are objects that are important to the flight inquiry system, following our team's naming conventions:

- Flight (all the information about this flight)
- Airline (Company with many flights)

## Install

## Setting up this script

- Create a personal Amadeus API access token in https://developers.amadeus.com/
- Copy `config/secrets_example.yml` to `config/secrets.yml` and update token
- Ensure correct version of Ruby install (see `.ruby-version` for `rbenv`)
- Run `bundle install`

## Running this script

To create fixtures, run:

```shell
ruby lib/project_info.rb
```

Fixture data should appear in `spec/fixtures/` folder