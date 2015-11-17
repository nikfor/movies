require_relative "movie"
require 'date'

class AncientMovie < Movie
  
  include ParseDate

  def initialize(url, name, year, country, date, genre, duration, point, author, actors)
    @weight = 0.5
    super
  end
  
  def description
    puts "#{@name} - old movie (#{@year} year)."
  end
  
  attr_reader :weight
  attr_accessor :user_point, :watched
end
