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
      map{ |row| 
        case row[2].to_i
          when 1900 .. 1945
            AncientMovie.new(*row) 
          when 1946 .. 1968
            ClassicMovie.new(*row) 
          when 1969 .. 2000
            ModernMovie.new(*row)
          when 2001 .. DateTime.now.year
            NewMovie.new(*row)
        end 
      }
  end

  def info
    @movie_arr.each{ |m| p m }
  end

  def user_score(name_of_mov, date_of_viewing, user_point)
    @movie_arr.each{ |mov| 
      if mov.name == name_of_mov
        mov.watched = Date.strptime(date_of_viewing, '%Y-%m-%d')
        mov.user_point = user_point
      end
    }
  end

  def recommend_from_notseen
    puts "\nFive not seen movies recommended for viewing:"
    i = 1
    @movie_arr.select{ |mov| mov.user_point.nil? }.
      each{ |mov| mov.point *= rand(100)*mov.weight }.
      sort_by(&:point).first(5).
      each{ |mov| print "#{i}. "; i+=1; mov.description}    
  end

  def recommend_from_seen
    puts "\nFive seen movies recommended for viewing:"
    i = 1
    @movie_arr.reject{ |mov| mov.user_point.nil? }.
      each{ |mov| mov.user_point *= rand(100)*(DateTime.now - mov.watched).to_i*mov.weight }.
      sort_by(&:user_point).first(5).
      each{ |mov| print "#{i}. "; i+=1; mov.description }                          
  end
=begin
  def name_output(movie)
    case movie
      when AncientMovie
        puts "#{movie.name} - old movie (#{movie.year} year)."
      when ClassicMovie
        puts "#{movie.name} - classic movie. Director - #{movie.author}."
      when ModernMovie
        puts "#{movie.name} - modern movie. Roles are played - #{movie.actors.join(", ")}."
      when NewMovie
        puts "#{movie.name} - new movie! Didn't look at the cinema???"
    end
  end
=end
end
