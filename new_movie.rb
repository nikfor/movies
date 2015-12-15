require_relative "movie"
require 'date'

class NewMovie < Movie

  @@weight_variable = 0.5

  def self.weight (value)
    @@weight_variable = value
  end

  def weight
    @@weight_variable
  end

  def description
    puts "#{@name} - new movie! Didn't look at the cinema???"
  end

  weight 0.7

  print_format {"%{name} - новое кино! А ты еще не посмотрел???"}

  filter { |year| (2001..DateTime.now.year).cover?(year) }

  attr_accessor :user_point, :watched
end
