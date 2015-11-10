require 'csv'
require 'date'
class Movie 
  def initialize(url, name, year, country, date, genre, duration, point, author, actors)
    @url      = url
    @name     = name
    @year     = year
    @country  = country
    @date     = date
    @genre    = genre
    @duration = duration
    @point    = point 
    @author   = author
    @actors   = actors
  end

  attr_reader :url, :name, :year, :country, :date, :genre, :duration, :point, :author, :actors
  attr_writer :url, :name, :year, :country, :date, :genre, :duration, :point, :author, :actors
end
