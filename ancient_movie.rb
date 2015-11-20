require_relative "movie"
require 'date'

class AncientMovie < Movie
  
  WEIGHT = 0.5

  def description
    puts "#{@name} - old movie (#{@year} year)."
  end
  
  attr_accessor :user_point, :watched
end
