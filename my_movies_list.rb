require_relative "movie"
require_relative "movies_list"
require_relative "ancient_movie"
require_relative "classic_movie"
require_relative "modern_movie"
require_relative "new_movie"
require 'date'
require 'csv'

class MyMoviesList < MovieList

  def initialize(type = "txt", path = "movies.txt", separator = '|')
    case type
    when "txt" then
      @movie_arr = CSV.open(path.to_s, col_sep: separator.to_s).to_a.
      map{ |row| Movie.create(row) }
    when "html" then
      @movie_arr = Array.new
      doc = Nokogiri::HTML(open("http://www.imdb.com/chart/top"))
      doc.search('td.titleColumn a').
        each{ |a| 
          film_page = Nokogiri::HTML(open("http://www.imdb.com#{a["href"]}"))
          url = "http://www.imdb.com/chart/top#{a["href"]}"
          name = a.content.to_s
          year = film_page.at('h1 span[id="titleYear"]').content.delete('()')[0..3].to_s
          country = film_page.at("h4[text()='Country:'] ~ a").content.to_s
          date = film_page.at('meta[itemprop="datePublished"]')["content"].to_s
          genre = film_page.search('span[itemprop="genre"]').map{ |genre| genre.content }.join(",").to_s
          duration = film_page.at('time[itemprop="duration"]')["datetime"].delete("PTM").concat(" min").to_s
          point = film_page.at('span[itemprop="ratingValue"]').content.to_s
          author = film_page.at('span[itemprop="director"] a span').content.to_s
          actors = film_page.search('span[itemprop="actors"] a span').map{ |act| act.content }.join(",").to_s
          @movie_arr.push(Movie.create([url, name, year, country, date, genre, duration, point, author, actors]))
        }
    end
  end

  def info
    @movie_arr.each{ |m| puts "#{m.name} #{m.year} #{m.point} #{m.actors.join(", ")}" }
  end

  def user_score(name_of_mov, date_of_viewing, user_point)
    @movie_arr.detect{ |mov| mov.name == name_of_mov }.
      score(date_of_viewing, user_point)
  end

  def recommend_from_notseen
    puts "\nFive not seen movies recommended for viewing:"
    i = 1
    @movie_arr.select{ |mov| mov.user_point.nil? }.
      sort_by{ |mov| mov.point *= rand(100)*mov.weight }.first(5).
      each_with_index{ |mov, index| print "#{index+1}. "; mov.description }     
  end

  def recommend_from_seen
    puts "\nFive seen movies recommended for viewing:"
    i = 1
    @movie_arr.reject{ |mov| mov.user_point.nil? }.
      sort_by{ |mov| mov.user_point *= rand(100)*(DateTime.now - mov.watched).to_i*mov.weight }.
      first(5).each_with_index{ |mov, index| print "#{index+1}. "; mov.descriptionn }                          
  end

  def recommend(count_films)
    @movie_arr.reject{ |mov| mov.user_point.nil? }.
      sort_by{ |mov| mov.user_point *= rand(100)*(DateTime.now - mov.watched).to_i*mov.weight }.
      first(count_films)                       
  end

  def save_to_yaml (path)
    File.open( path, "w") { |f| f.write(@movie_arr.to_yaml) }
  end

  def load_from_yaml (path)
    @movie_arr = YAML.load (File.open(path))
  end

end
