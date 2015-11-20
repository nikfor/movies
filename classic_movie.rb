require_relative "movie"
require 'date'

class ClassicMovie < Movie
  
  WEIGHT = 0.8

  def description
    puts "#{@name} - classic movie. Director - #{@author}."
  end

  attr_accessor :user_point, :watched
end
