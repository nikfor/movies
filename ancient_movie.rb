require_relative "movie"
require 'date'

class AncientMovie < Movie
  
  def description
    puts "#{@name} - old movie (#{@year} year)."
  end

  weight 0.5

  print_format "%{name} — старый фильм (%{year} год)"

  filter { |year| (1900..1945).cover?(year) }


  attr_accessor :user_point, :watched
end
