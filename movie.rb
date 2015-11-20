require 'csv'
require 'date'


class Movie 

  include ParseDate
  
  def initialize(url, name, year, country, date, genre, duration, point, author, actors)
    @url      = url
    @name     = name
    @year     = year.to_i
    @country  = country
    @date     = parse_date(date)
    @genre    = genre
    @duration = duration.to_i
    @point    = point.to_f 
    @author   = author
    @actors   = actors.split(',')
  end

  def self.create(arr_f)
    case arr_f[2].to_i
    when 1900 .. 1945
      AncientMovie.new(*arr_f) 
    when 1946 .. 1968
      ClassicMovie.new(*arr_f) 
    when 1969 .. 2000
      ModernMovie.new(*arr_f)
    when 2001 .. DateTime.now.year
      NewMovie.new(*arr_f)
    end 
  end

  def parse_date(input_date)
    case input_date.length
    when 10
      Date.strptime(input_date, '%Y-%m-%d')
    when 7 
      Date.strptime(input_date, '%Y-%m') 
    when 4
      nil
    end
  end

  attr_reader :url, :name, :year, :country, :date, :genre, :duration, :point, :author, :actors
  attr_writer :point
  private :parse_date
end
