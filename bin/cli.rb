# Here's your CLI class! I've included some starter code so you
#   can get a sense on how you might use it! Remember: this
#   class doesn't represent anything in your databse: it's
#   here simply to encapsulate your CLI methods!

# Pro-tip: think about how you might use class and instance
#   variables in a class like this!

class CLI

  def initialize
    puts "Welcome to EventFindr"
    puts 
    puts
  end


  def main_menu
    Event.destroy_all
    Venue.destroy_all
    Attraction.destroy_all
    puts "Choose an option: "
    puts "-----------------"
    puts "1. City & Date"
    puts "2. Artist & City"
    puts "3. What's going onsale soon (by city)"
    puts "4. I'm feeling Lucky tonight (by city)"
    puts "5. Exit"
    puts
    input = get_user_input
    if input == "1"
      puts "Which city?"
      city = get_user_input
      puts "What date? (yyyy-mm-dd)"
      date = get_user_input
      get_events_for_city_and_date(city, date)
    elsif input == '2'
      puts "Which artist?"
      artist = get_user_input
      puts "Which city?"
      city = get_user_input
      get_events_for_artist_and_city(artist, city)
    elsif input == '3'
      puts "Which city?"
      city = get_user_input
      onsale_soon_by_city(city)
    elsif input == '4'
      puts "Which city?"
      city = get_user_input
      im_feeling_lucky_tonight(city)
    elsif input == '5'
      #todo
    end
    #Code that filters based on input
    return self.main_menu
  end



  def get_user_input
    gets.chomp.downcase
  end

end
