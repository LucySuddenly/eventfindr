require 'rest-client'
require 'json'
require 'pry'

def get_events_for_city_and_date
  #make the web request
  event_array = []
  puts "Which city?"
  city = get_user_input
  puts "What date? (yyyy-mm-dd)"
  date = get_user_input
  response_string = RestClient.get('https://app.ticketmaster.com/discovery/v2/events.json?apikey='+ $key + '&city=' + city + '&size=50&localStartDateTime=' + date + 'T00:00:00,' + date + 'T11:59:59')
  response_hash = JSON.parse(response_string)

  response_hash["_embedded"]["events"].each do |event_hash|
    name = event_hash["name"]
    date = event_hash["dates"]["start"]["localDate"]
    url = event_hash["url"]
    price_range = "Prices range from #{event_hash["priceRanges"][0]["min"]} to #{event_hash["priceRanges"][0]["max"]}."

    Event.new(:name => name, :date => date, :url => url, :price_range => price_range)
    binding.pry
    #def Event (name, date, url, price_range)
  end
end
