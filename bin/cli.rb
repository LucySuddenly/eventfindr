# Here's your CLI class! I've included some starter code so you
#   can get a sense on how you might use it! Remember: this
#   class doesn't represent anything in your databse: it's
#   here simply to encapsulate your CLI methods!

# Pro-tip: think about how you might use class and instance
#   variables in a class like this!

class CLI

  def initialize
    puts
    puts "Welcome to ..."
  end


  def main_menu
    Event.destroy_all
    Venue.destroy_all
    Attraction.destroy_all
    puts
    puts " ______               _   ______ _           _"
    puts "|  ____|             | | |  ____(_)         | |"
    puts "| |____   _____ _ __ | |_| |__   _ _ __   __| |_ __"
    puts "|  __\\ \\ / / _ \\ '_ \\| __|  __| | | '_ \\ / _` | '__|"
    puts "| |____ V /  __/ | | | |_| |    | | | | | (_| | |"
    puts "|______\\_/ \\___|_| |_|\\__|_|    |_|_| |_|\\__,_|_|"
    puts
    puts "Available Search Options"
    puts "-----------------------------------------"
    puts "1. Find events by city & date."
    puts "2. Find events by performer & city."
    puts "3. What tickets go onsale soon near me?"
    puts "4. Pick an event for me to attend tonight!"
    puts "5. Exit"
    puts
    puts "Enter your selection:"
    input = get_user_input
    if input == "1"
      puts "Which city?"
      city = get_user_input
      puts "What date? (yyyy-mm-dd)"
      date = get_user_input
      get_events_for_city_and_date(city, date)
    elsif input == '2'
      puts "Which performer?"
      artist = get_user_input
      puts "Which city?"
      city = get_user_input
      get_events_for_artist_and_city(artist, city)
    elsif input == '3'
      puts "In which city are you located?"
      city = get_user_input
      onsale_soon_by_city(city)
    elsif input == '4'
      puts "In which city are you located?"
      city = get_user_input
      choose_a_random_event(city)
    elsif input == '5'
    exit
    else
      puts "Invalid entry, please press enter to try again."
      gets
    end
    return self.main_menu
  end

  def event_info(event)
    puts
    puts "Event Info:"
    puts "---------------------------"
    puts "Event Name: #{event.name}"
    puts " Performer: #{event.attraction.name}"
    puts "     Genre: #{event.attraction.genre}"
    puts "      Date: #{event.date.to_s[0..9]}"
    puts "      Time: #{event.event_time}"
    puts "     Venue: #{event.venue.name}"
    puts "   Address: #{event.venue.address}"
    puts
    puts "Available Options:"
    # puts "----------------------------"
    puts "1. Open browser to see ticket availability and pricing."
    puts "2. Go back to main menu."
    puts
    puts "Enter your selection:"
    input = get_user_input
    if input == "1"
      launch_url(event)
    elsif input == "2"
      self.main_menu
    else
      puts "Invalid entry, please press enter to try again."
      gets
      self.event_info(event)
    end
  end

  def event_information_select_prompt
    puts "Select the number of an event for more information."
    get_user_input
  end

  def onsale_information_select_prompt
    puts "Select the number of an event for onsale information."
    get_user_input
  end


  def get_user_input
    gets.chomp.downcase
  end

end
