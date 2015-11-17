require_relative "movie"
require 'date'

class ModernMovie < Movie
  
  include ParseDate

  def initialize(url, name, year, country, date, genre, duration, point, author, actors)
    @weight = 0.8
    super
  end
  
  def description
    puts "#{@name} - modern movie. Roles are played - #{@actors.join(", ")}."
  end

  attr_reader :weight
  attr_accessor :user_point, :watched
end
