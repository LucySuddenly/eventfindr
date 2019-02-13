require 'rest-client'
require 'json'
require 'pry'

def json_iterator_convert_to_objects(response_hash)
    if response_hash["page"]["totalElements"] == 0
      puts "No search results, please try again."
      puts 
      self.main_menu
    else
      response_hash["_embedded"]["events"].each do |event_hash|
        begin
          attraction_name = event_hash["_embedded"]["attractions"][0]["name"]
          attraction_genre = event_hash["_embedded"]["attractions"][0]["classifications"][0]["genre"]["name"]
        rescue NoMethodError
          attraction_name = event_hash["name"]
          attraction_genre = "Genre is not listed."
        end
        if a = Venue.find_by(:name => event_hash["_embedded"]["venues"][0]["name"])
          #do nothing
        else
          a = Venue.create(:name => event_hash["_embedded"]["venues"][0]["name"], :address => "#{event_hash["_embedded"]["venues"][0]["address"]["line1"]}, #{event_hash["_embedded"]["venues"][0]["city"]["name"]}, #{event_hash["_embedded"]["venues"][0]["state"]["stateCode"]} #{event_hash["_embedded"]["venues"][0]["postalCode"]}", :city => event_hash["_embedded"]["venues"][0]["city"]["name"])
        end
        if b = Attraction.find_by(:name => attraction_name)
          #do nothing
        else
          b = Attraction.create(:name => attraction_name, :genre => attraction_genre)
        end
        c = Event.create(:name => event_hash["name"], :date => event_hash["dates"]["start"]["localDate"], :url => event_hash["url"])
        c.venue = a
        c.attraction = b
        c.save
      end
    end
end



def get_events_for_city_and_date
  puts "Which city?"
  city = get_user_input
  city = city.downcase
  city = city.split(' ')
  if city[-1] == 'city'
    city = city[-2]
  else
    city = city[-1]
  end
  puts "What date? (yyyy-mm-dd)"
  date = get_user_input
  response_string = RestClient.get('https://app.ticketmaster.com/discovery/v2/events.json?apikey='+ $key + '&city=' + city + '&size=50&localStartDateTime=' + date + 'T00:00:00,' + date + 'T23:59:59')
  response_hash = JSON.parse(response_string)
  json_iterator_convert_to_objects(response_hash)
end

def get_events_for_artist_and_city
  puts "Which artist?"
  artist = get_user_input
    #operate on artist to make camelCase
  puts "Which city?"
  city = get_user_input
  response_string = RestClient.get('https://app.ticketmaster.com/discovery/v2/events.json?apikey='+ $key + '&city=' + city + '&size=50&keyword=' + artist )
  response_hash = JSON.parse(response_string)
  json_iterator_convert_to_objects(response_hash)
end
