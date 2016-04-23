require_relative "movie"
require 'date'

class NewMovie < Movie
   
  def description
    puts "#{@name} - new movie! Didn't look at the cinema???"
  end

  weight 0.7

  print_format "%{name} - новое кино! А ты еще не посмотрел???"

  filter { |year| (2001..DateTime.now.year+200).cover?(year) }

  attr_accessor :user_point, :watched
end
