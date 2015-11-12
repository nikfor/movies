require 'csv'
require 'date'
require_relative 'movie' 

class MovieList
  
  def initialize(path, separator)
    @movie_arr = CSV.open(path.to_s, col_sep: separator.to_s).to_a.
      map{ |row| Movie.new(*row)}
  end
    
  def count_movie_in_month
    puts "------------------------------------------------------------\n\nCount movies in month:\n\n"
    @movie_arr.map{ |f| f.date }.compact.
    group_by{ |d| d.mon }.sort_by(&:first).
    each{ |mon_num, group| puts "#{Date::MONTHNAMES[mon_num]} - #{group.size} films" }
  end

  def five_longest
    puts "------------------------------------------------------------\nFive longest films:"
    @movie_arr.sort_by{ |row| row.duration.to_i }.
      last(5).reverse.
      each{|f| puts "#{f.name} #{f.genre} #{f.duration}" }
  end

  def select_by_genre(ingenre)
    puts "------------------------------------------------------------\n#{ingenre} films:"
    @movie_arr.sort_by(&:date).
      select{ |f| f.genre.include? ingenre}.
      each{|f| puts "#{f.name} #{f.genre} #{f.duration}" }
  end

  def all_directors
    puts "------------------------------------------------------------\nAll directors alphabetically:"
    @movie_arr.map(&:author).uniq.
      sort_by{ |d| d.split(' ').last }.
      each{ |d| puts d } 
  end

  def count_shot_not_country(not_country)
    puts "------------------------------------------------------------\nCount films shot not in the #{not_country}:"
    puts @movie_arr.reject{ |f| f.country.include? not_country}.count
  end

  def group_by_produce
    puts "------------------------------------------------------------\nGroup films by produce:"
    @movie_arr.group_by(&:author).
      each{|auth, mov| 
        puts "#{auth} \n - #{mov.map{ |m| m.name}.join("\n - ")}"
      }       
  end
                                         
  def rait_actors
    puts "------------------------------------------------------------\nHow many time was removed each actor:"
    @movie_arr.map(&:actors).
      flatten.sort.group_by(&:itself).
      each{ |act, group| puts "#{act} - #{group.size}" }
  end

  def sort_by_field(field)
    field == "duration" ? unit_meash = "min" : unit_meash = ""
    @movie_arr.sort_by{ |row| row.send field}.
      each{ |row| puts "#{row.name} - #{row.send field} #{unit_meash}" }
  end
end
