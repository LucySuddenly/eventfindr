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
  puts response_hash
  binding.pry
  # response_hash["results"].each do |character_hash|
  #   if character_hash["name"] == character_name
  #     character_hash["films"].each do |film, index|
  #       film_string = RestClient.get(film)
  #       film_array << JSON.parse(film_string)
  #     end
  #   end
end
