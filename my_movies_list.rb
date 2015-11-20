require_relative "movie"
require_relative "movies_list"
require_relative "ancient_movie"
require_relative "classic_movie"
require_relative "modern_movie"
require_relative "new_movie"
require 'date'
require 'csv'

class MyMoviesList < MovieList

  def initialize(path, separator)
    @movie_arr = CSV.open(path.to_s, col_sep: separator.to_s).to_a.
      map{ |row| Movie.create(row) }
  end

  def info
    @movie_arr.each{ |m| p m }
  end

  def user_score(name_of_mov, date_of_viewing, user_point)
    @movie_arr.detect{ |mov| mov.name == name_of_mov }.
      score(date_of_viewing, user_point)
  end

  def recommend_from_notseen
    puts "\nFive not seen movies recommended for viewing:"
    i = 1
    @movie_arr.select{ |mov| mov.user_point.nil? }.
      sort_by{ |mov| mov.point *= rand(100)*mov.class::WEIGHT }.first(5).
      each{ |mov| print "#{i}. "; i+=1; mov.description}    
  end

  def recommend_from_seen
    puts "\nFive seen movies recommended for viewing:"
    i = 1
    @movie_arr.reject{ |mov| mov.user_point.nil? }.
      sort_by{ |mov| mov.user_point *= rand(100)*(DateTime.now - mov.watched).to_i*mov.class::WEIGHT }.
      first(5).each{ |mov| print "#{i}. "; i+=1; mov.description }                          
  end
end
