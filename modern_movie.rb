require_relative "movie"
require 'date'

class ModernMovie < Movie

  WEIGHT = 0.8

  def description
    puts "#{@name} - modern movie. Roles are played - #{@actors.join(", ")}."
  end

  attr_accessor :user_point, :watched
end
