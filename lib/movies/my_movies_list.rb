require_relative "movie"
require_relative "movies_list"
require_relative "ancient_movie"
require_relative "classic_movie"
require_relative "modern_movie"
require_relative "new_movie"
require 'date'
require 'csv'
require 'themoviedb-api'
require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'themoviedb-api'

class MyMoviesList < MovieList

  Tmdb::Api.key("20de3eaf1221e1c1fb48f44ab5178cfb")

  def initialize(array_of_movies)
    @movie_arr = array_of_movies
  end

  def self.from_file (path = "../files/movies.txt", separator = '|')
    raise ArgumentError, "such file doesn't exist" unless File.exists?(path)
    self.new( CSV.open(path.to_s, col_sep: separator.to_s).to_a.
      map{ |row| Movie.create(row) } )
  end

  def self.from_yaml (path)
    raise ArgumentError, "such file doesn't exist" unless File.exists?(path)
    self.new(YAML.load (File.open(path)))
  end

  def self.from_imdb
    movies = []
      doc = Nokogiri::HTML(open("http://www.imdb.com/chart/top"))
      doc.search('td.titleColumn a').
        each{ |a| 
          movies.push(Movie.create(get_movie_imdb("http://www.imdb.com#{a["href"]}")))
        }
    self.new(movies)
  end

  def self.from_tmdb
    movies = []
    movies = (1..2).map { |pg|
      Tmdb::Movie.top_rated(page: pg).results.map{|mov| Movie.create(get_movie_tmdb(mov.id)) }
    }.flatten
    self.new(movies)
  end
  

  def info  
    @movie_arr.each{ |m| puts "#{m.name} #{m.date} #{m.point} #{m.actors.join(", ")}" }
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
    raise ArgumentError, "such file doesn't exist" unless File.exists?(path)
    @movie_arr = YAML.load (File.open(path))
  end


  private

  def self.get_movie_imdb (link)
    film_page = Nokogiri::HTML(open(link))
    url = link
    name = film_page.at("h1.header span.itemprop[itemprop='name']").content.to_s
    year = film_page.at('h1.header span.nobr').content.delete('()')[0..3].to_s
    country = film_page.at("h4[text()='Country:'] ~ a").content.to_s
    date = film_page.at('meta[itemprop="datePublished"]')["content"].to_s
    genre = film_page.search('span[itemprop="genre"]').map{ |genre| genre.content }.join(",").to_s
    duration = film_page.at('time[itemprop="duration"]')["datetime"].delete("PTM").concat(" min").to_s
    point = film_page.at('span[itemprop="ratingValue"]').content.to_s
    author = film_page.at('[itemprop="director"] a span').content.to_s
    actors = film_page.search('[itemprop="actors"] a span').map{ |act| act.content }.join(",").to_s
    [url, name, year, country, date, genre, duration, point, author, actors]
  end

  def self.get_movie_tmdb (id)
    mov = Tmdb::Movie.detail(id)
    url = mov.homepage
    name = mov.title
    year = mov.release_date.slice(0, 4)
    country = mov.production_countries.map(&:name).join(",")
    date = mov.release_date
    genre = mov.genres.map(&:name).join(",")
    duration = mov.runtime
    point = mov.vote_average
    author = Tmdb::Movie.director(id).first.nil? ? " " : Tmdb::Movie.director(id).first.name
    actors = Tmdb::Movie.cast(id).first(3).map(&:name).join(",")
    [url, name, year, country, date, genre, duration, point, author, actors]
  end

end
