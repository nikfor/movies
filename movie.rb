require 'csv'
require 'date'
class Movie 
  def initialize(url, name, year, country, date, genre, duration, point, author, actors)
    @url      = url
    @name     = name
    @year     = year.to_i
    @country  = country
    case date.length
    when 10
      @date = Date.strptime(date, '%Y-%m-%d')
    when 7 
      @date = Date.strptime(date, '%Y-%m')  # не знаю как превратить день в nil(1 января)? тоже самое с месяцем
    when 4
      @date = Date.strptime(date, '%Y')
    end
    @genre    = genre
    @duration = duration.to_i
    @point    = point.to_f 
    @author   = author
    @actors   = actors.split(',')
  end

  attr_reader :url, :name, :year, :country, :date, :genre, :duration, :point, :author, :actors

end
