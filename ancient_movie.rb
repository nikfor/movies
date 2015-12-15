require_relative "movie"
require 'date'

class AncientMovie < Movie
  
  @@weight_variable = 0.4

  def self.weight (value)
    @@weight_variable = value
  end

  def weight
    @@weight_variable
  end

  def description
    puts "#{@name} - old movie (#{@year} year)."
  end

  weight 0.5

  print_format {"%{title} — старый фильм (%{year} год)"}

  filter { |year| (1900..1945).cover?(year) }


  attr_accessor :user_point, :watched
end
