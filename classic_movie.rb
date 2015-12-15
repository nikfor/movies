require_relative "movie"
require 'date'

class ClassicMovie < Movie
  
  @@weight_variable = 0.5

  def self.weight (value)
    @@weight_variable = value
  end

  def weight
    @@weight_variable
  end

  def description
    puts "#{@name} - classic movie. Director - #{@author}."
  end

  weight 0.8

  print_format {"%{name} - классика. Режиссер - %{author}."}

  filter { |year| (1946..1968).cover?(year) }


  attr_accessor :user_point, :watched
end
