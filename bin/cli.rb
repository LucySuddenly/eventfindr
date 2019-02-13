# Here's your CLI class! I've included some starter code so you
#   can get a sense on how you might use it! Remember: this
#   class doesn't represent anything in your databse: it's
#   here simply to encapsulate your CLI methods!

# Pro-tip: think about how you might use class and instance
#   variables in a class like this!

class CLI

  def initialize
    puts "Initializing new CLI"
  end
  
  def main_menu
    puts "Choose an option: "
    puts "1. City & Date"
    puts "2. Artist & City"
    puts "3. Venue"
    input = get_user_input
    if input == "1"
      get_events_for_city_and_date
    end
    #Code that filters based on input
    return self.main_menu
  end



  def get_user_input
    gets.chomp.downcase
  end

end
