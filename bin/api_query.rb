require 'rest-client'
require 'json'
require 'pry'

def display_output
  puts
  Event.all.each_with_index do |event, index|
    puts "#{(index + 1)}. #{event.name} (#{event.event_time})"
  end
  puts
end

def display_output_with_date
  puts
  Event.all.each_with_index do |event, index|
    puts "#{(index + 1)}. #{event.name} (#{event.date.to_s[0..9]}, #{event.event_time})"
  end
  puts
end

def retrieve_user_selection
  input = event_information_select_prompt
  Event.all[input.to_i - 1]
end

def retrieve_user_selection_for_presales
  input = onsale_information_select_prompt
  Event.all[input.to_i - 1]
end


def launch_url(event)
  Launchy.open(event.url)
end

def check_if_no_results(response_hash)
  if response_hash["page"]["totalElements"] == 0
    puts
    puts "No search results."
    puts
    puts "Press enter to return to main menu."
    gets
    self.main_menu
  end
end

def return_name_or_handle_error(event_hash)
  begin
    event_hash["_embedded"]["attractions"][0]["name"]
  rescue NoMethodError
    event_hash["name"]
  end
end

def return_genre_or_handle_error(event_hash)
  begin
    event_hash["_embedded"]["attractions"][0]["classifications"][0]["genre"]["name"]
  rescue NoMethodError
    "Genre is not listed."
  end
end

def check_if_db_contains_venue_else_create_it(event_hash)
  begin
    if Venue.find_by(:name => event_hash["_embedded"]["venues"][0]["name"])
      Venue.find_by(:name => event_hash["_embedded"]["venues"][0]["name"])
    else
      Venue.create(:name => event_hash["_embedded"]["venues"][0]["name"], :address => "#{event_hash["_embedded"]["venues"][0]["address"]["line1"]}, #{event_hash["_embedded"]["venues"][0]["city"]["name"]}, #{event_hash["_embedded"]["venues"][0]["state"]["stateCode"]} #{event_hash["_embedded"]["venues"][0]["postalCode"]}", :city => event_hash["_embedded"]["venues"][0]["city"]["name"])
    end
  rescue NoMethodError
    Venue.create(:name => "Unlisted")
  end
end

def check_if_db_contains_attraction_else_create_it(event_hash, attraction_name, attraction_genre)
  begin
    if Attraction.find_by(:name => attraction_name)
      Attraction.find_by(:name => attraction_name)
    else
      Attraction.create(:name => attraction_name, :genre => attraction_genre)
    end
  rescue NoMethodError
    Attraction.create(:name => "Unlisted")
  end
end

def create_event(event_hash)
  time = fix_time(event_hash["dates"]["start"]["localTime"])
  Event.create(:name => event_hash["name"], :date => event_hash["dates"]["start"]["localDate"], :url => event_hash["url"], :event_time => time)
end

def fix_time(time)
  begin
    time = time.split(':')
    time[0] = time[0].to_i
    if time[0] > 12
      time[0] = time[0] - 12
      return "#{time[0]}:#{time[1]} PM"
    else
      return "#{time[0]}:#{time[1]} AM"
    end
  rescue NoMethodError
    "No time listed."
  end
end

def assign_relationships(venue, attraction, event)
  event.venue = venue
  event.attraction = attraction
  event.save
end

def convert_json_data_to_ruby_objects(response_hash)
  check_if_no_results(response_hash)
  response_hash["_embedded"]["events"].each do |event_hash|
    attraction_name = return_name_or_handle_error(event_hash)
    attraction_genre = return_genre_or_handle_error(event_hash)
    venue = check_if_db_contains_venue_else_create_it(event_hash)
    attraction = check_if_db_contains_attraction_else_create_it(event_hash, attraction_name, attraction_genre)
    event = create_event(event_hash)
    assign_relationships(venue, attraction, event)
  end
end

def get_events_for_city_and_date(city, date)
  response_string = RestClient.get('https://app.ticketmaster.com/discovery/v2/events.json?apikey='+ $key + '&city=' + city + '&size=50&localStartDateTime=' + date + 'T00:00:00,' + date + 'T23:59:59')
  response_hash = JSON.parse(response_string)
  convert_json_data_to_ruby_objects(response_hash)
  display_output
  event = retrieve_user_selection
  event_info(event)
end

def get_events_for_artist_and_city(artist, city)
  response_string = RestClient.get('https://app.ticketmaster.com/discovery/v2/events.json?apikey='+ $key + '&city=' + city + '&size=25&keyword=' + artist )
  response_hash = JSON.parse(response_string)
  convert_json_data_to_ruby_objects(response_hash)
  display_output_with_date
  event = retrieve_user_selection
  event_info(event)
end

def onsale_soon_by_city(city)
  response_string = RestClient.get('https://app.ticketmaster.com/discovery/v2/events.json?apikey='+ $key + '&city=' + city + '&size=25&sort=onSaleStartDate,asc&onsaleOnAfterStartDate=' + DateTime.now.to_s[0..9])
  response_hash = JSON.parse(response_string)
  convert_json_data_to_ruby_objects(response_hash)
  display_output_with_date
  event = retrieve_user_selection_for_presales
  event_info(event)
end

def choose_a_random_event(city)
  response_string = RestClient.get('https://app.ticketmaster.com/discovery/v2/events.json?apikey='+ $key + '&city=' + city + '&size=25&localStartDateTime=' + DateTime.now.to_s[0..9] + 'T00:00:00,' + DateTime.now.to_s[0..9] + 'T23:59:59&sort=random')
  response_hash = JSON.parse(response_string)
  convert_json_data_to_ruby_objects(response_hash)
  launch_url(Event.all[rand(0..Event.all.count - 1)])
end
