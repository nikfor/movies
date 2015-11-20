require_relative "movie"
require 'date'

class NewMovie < Movie

  WEIGHT = 0.7

  def description
    puts "#{@name} - new movie! Didn't look at the cinema???"
  end

  attr_accessor :user_point, :watched
end
