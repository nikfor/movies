require_relative "movie"
require 'date'

class ClassicMovie < Movie
  
  include ParseDate

  def initialize(url, name, year, country, date, genre, duration, point, author, actors)
    @weight = 0.8
    super
  end

  def description
    puts "#{@name} - classic movie. Director - #{@author}."
  end
  
  attr_reader :weight
  attr_accessor :user_point, :watched
end
