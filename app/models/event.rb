class Event < ActiveRecord::Base
  belongs_to :venue
  belongs_to :attraction

  # def initialize (name, date, url, price_range)
  #   @name = name
  #   @date = date
  #   @url = url
  #   @price_range = price_range
  # end

end
