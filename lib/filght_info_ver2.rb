# frozen_string_literal: true

require 'amadeus'
require 'json'
require 'yaml'

def set_amadeus_account
  config = YAML.safe_load_file('../config/secrets.yml')

  Amadeus::Client.new({
                        client_id: config['client_id'],
                        client_secret: config['client_secret']
                      })
end

def get_data(amadeus)
  response = amadeus.shopping.flight_offers_search.get(
    originLocationCode: 'TPE',
    destinationLocationCode: 'TYO',
    departureDate: '2023-11-02',
    adults: 1,
    max: 1
  )

  JSON.pretty_generate(JSON.parse(response.body))
rescue Amadeus::ResponseError => e
  puts e
end

amadeus = set_amadeus_account
result = get_data(amadeus)
File.write('../spec/fixtures/amadeus_results.yml', result.to_yaml)
