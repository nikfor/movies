require_relative "movie"
require 'date'

class NewMovie < Movie
  
  include ParseDate
  
  def initialize(url, name, year, country, date, genre, duration, point, author, actors)
    @weight = 0.7
    super
  end
  
  def description
    puts "#{@name} - new movie! Didn't look at the cinema???"
  end
  
  attr_reader :weight
  attr_accessor :user_point, :watched
end
