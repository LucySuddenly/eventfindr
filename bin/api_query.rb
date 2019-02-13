require 'rest-client'
require 'json'
require 'pry'

def display_output
  Event.all.each_with_index do |event, index|
    puts "#{(index + 1)}. #{event.name}"
  end
end

def display_output_with_date
  Event.all.each_with_index do |event, index|
    puts "#{(index + 1)}. #{event.name} (#{event.date.to_s[0..9]})"
  end
end

def get_detailed_info
  puts "Select the number of an event to purchase tickets."
  input = get_user_input
  Event.all[input.to_i - 1]
end

def launch_url(event)
  Launchy.open(event.url)
end

def check_if_no_results(response_hash)
  if response_hash["page"]["totalElements"] == 0
    puts "No search results, please try again."
    puts
    self.main_menu
  end
end

def attraction_name_rescue(event_hash)
  begin
    event_hash["_embedded"]["attractions"][0]["name"]
  rescue NoMethodError
    event_hash["name"]
  end
end

def attraction_genre_rescue(event_hash)
  begin
    event_hash["_embedded"]["attractions"][0]["classifications"][0]["genre"]["name"]
  rescue NoMethodError
    "Genre is not listed."
  end
end

def assuring_venue_is_unique(event_hash)
  #check to see if DB contains venue, else create it
  if Venue.find_by(:name => event_hash["_embedded"]["venues"][0]["name"])
    Venue.find_by(:name => event_hash["_embedded"]["venues"][0]["name"])
  else
    Venue.create(:name => event_hash["_embedded"]["venues"][0]["name"], :address => "#{event_hash["_embedded"]["venues"][0]["address"]["line1"]}, #{event_hash["_embedded"]["venues"][0]["city"]["name"]}, #{event_hash["_embedded"]["venues"][0]["state"]["stateCode"]} #{event_hash["_embedded"]["venues"][0]["postalCode"]}", :city => event_hash["_embedded"]["venues"][0]["city"]["name"])
  end
end

def assuring_attraction_is_unique(event_hash, attraction_name, attraction_genre)
  #check to see if DB contains attraction, else create it
  if Attraction.find_by(:name => attraction_name)
    Attraction.find_by(:name => attraction_name)
  else
    Attraction.create(:name => attraction_name, :genre => attraction_genre)
  end
end

def create_event(event_hash)
  Event.create(:name => event_hash["name"], :date => event_hash["dates"]["start"]["localDate"], :url => event_hash["url"])
end

def assign_relationships(a, b, c)
  c.venue = a
  c.attraction = b
  c.save
end

def convert_json_data_to_ruby_objects(response_hash)
    check_if_no_results(response_hash)
      response_hash["_embedded"]["events"].each do |event_hash|
        attraction_name = attraction_name_rescue(event_hash)
        attraction_genre = attraction_genre_rescue(event_hash)
        a = assuring_venue_is_unique(event_hash)
        b = assuring_attraction_is_unique(event_hash, attraction_name, attraction_genre)
        c = create_event(event_hash)
        assign_relationships(a, b ,c)
    end
end

def get_events_for_city_and_date(city, date)
  response_string = RestClient.get('https://app.ticketmaster.com/discovery/v2/events.json?apikey='+ $key + '&city=' + city + '&size=50&localStartDateTime=' + date + 'T00:00:00,' + date + 'T23:59:59')
  response_hash = JSON.parse(response_string)
  convert_json_data_to_ruby_objects(response_hash)
  display_output
  input = get_detailed_info
  launch_url(input)
end

def get_events_for_artist_and_city(artist, city)
  response_string = RestClient.get('https://app.ticketmaster.com/discovery/v2/events.json?apikey='+ $key + '&city=' + city + '&size=50&keyword=' + artist )
  response_hash = JSON.parse(response_string)
  convert_json_data_to_ruby_objects(response_hash)
  display_output_with_date
  input = get_detailed_info
  launch_url(input)
end

def onsale_soon_by_city(city)
  response_string = RestClient.get('https://app.ticketmaster.com/discovery/v2/events.json?apikey='+ $key + '&city=' + city + '&size=50&sort=onSaleStartDate,asc&onsaleOnAfterStartDate=' + DateTime.now.to_s[0..9])
  response_hash = JSON.parse(response_string)
  convert_json_data_to_ruby_objects(response_hash)
  display_output_with_date
  input = get_detailed_info
  launch_url(input)
end

def im_feeling_lucky_tonight(city)
  response_string = RestClient.get('https://app.ticketmaster.com/discovery/v2/events.json?apikey='+ $key + '&city=' + city + '&size=50&localStartDateTime=' + DateTime.now.to_s[0..9] + 'T00:00:00,' + DateTime.now.to_s[0..9] + 'T23:59:59&sort=random')
  response_hash = JSON.parse(response_string)
  convert_json_data_to_ruby_objects(response_hash)
  launch_url(Event.all[rand(0..Event.all.count - 1)])
end
