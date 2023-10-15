require 'amadeus'
require 'json'
require 'yaml'

config = YAML.safe_load_file('../config/secrets_amadeus.yml')

amadeus = Amadeus::Client.new({
  client_id: config['client_id'],
  client_secret: config['client_secret']
})

begin
  response = amadeus.shopping.flight_offers_search.get(
    originLocationCode: 'TPE',
    destinationLocationCode: 'TYO',
    departureDate: '2023-11-02',
    adults: 1,
    max: 1
  )

  # 使用 JSON.pretty_generate 格式化 JSON 数据
  formatted_json = JSON.pretty_generate(JSON.parse(response.body))

  puts formatted_json
rescue Amadeus::ResponseError => error
  puts error
end

# require 'amadeus'

# amadeus = Amadeus::Client.new({
#   client_id: 'HGNwfx6IawhSj56BLum0n63UJKKxZfWl',
#   client_secret: 'iYxACQOQFEbyxjlT'
# })

# begin
#   puts amadeus.shopping.flight_offers_search.get(originLocationCode: 'TPE', destinationLocationCode: 'TYO', departureDate: '2023-11-02', adults: 1, max: 1).body
# rescue Amadeus::ResponseError => error
#   puts error
# end
