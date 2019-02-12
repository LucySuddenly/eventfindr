class Venue < ActiveRecord::Base
  has_many :events
  has_many :attractions, through: :events
end
