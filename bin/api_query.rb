require 'rest-client'
require 'json'
require 'pry'

def get_events_for_city_and_date
  puts "Which city?"
  city = get_user_input
  puts "What date? (yyyy-mm-dd)"
  date = get_user_input
  response_string = RestClient.get('https://app.ticketmaster.com/discovery/v2/events.json?apikey='+ $key + '&city=' + city + '&size=50&localStartDateTime=' + date + 'T00:00:00,' + date + 'T23:59:59')
  response_hash = JSON.parse(response_string)
  response_hash["_embedded"]["events"].each do |event_hash|
    event_name = event_hash["name"]
    event_date = event_hash["dates"]["start"]["localDate"]
    event_url = event_hash["url"]
    venue_name = event_hash["_embedded"]["venues"][0]["name"]
    venue_address = "#{event_hash["_embedded"]["venues"][0]["address"]["line1"]}, #{event_hash["_embedded"]["venues"][0]["city"]["name"]}, #{event_hash["_embedded"]["venues"][0]["state"]["stateCode"]} #{event_hash["_embedded"]["venues"][0]["postalCode"]}"
    venue_city = event_hash["_embedded"]["venues"][0]["city"]["name"]
    #binding.pry
    Venue.create(:name => venue_name, :address => venue_address, :city => venue_city) #name, address, city
    Attraction.create() #name, genre
    Event.create(:name => event_name, :date => event_date, :url => event_url)
  end
  binding.pry
end
