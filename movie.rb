require 'csv'
require 'date'


class Movie 

  include ParseDate

  @@hsh_of_clssfilt = {}
  @@hsh_of_printfrmt = {}

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
    @@hsh_of_clssfilt.detect { |key, val| val.call(arr_f[2].to_i) }[0].new(*arr_f)
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

  def has_genres?(genres)
    !(genres & @genre.split(",")).empty?
  end

  def self.filter(&block)
    @@hsh_of_clssfilt[self] = block
  end

  def self.print_format(&block)
    @@hsh_of_printfrmt[self] = block
  end

  def descriptionn
    tmp_hsh = { :url => @url, 
      :name => @name, 
      :year => @year, 
      :country => @country, 
      :date => @date, 
      :genre => @genre, 
      :duration => @duration, 
      :point => @point, 
      :author => @author, 
      :actors => @actors.join(", ") 
    }
    puts sprintf( @@hsh_of_printfrmt[self.class].call, tmp_hsh)
  end

  def method_missing (name, *args, &block)
    @genre.include?(name.to_s.chop.capitalize) 
  end

  attr_reader :url, :name, :year, :country, :date, :genre, :duration, :point, :author, :actors
  attr_writer :point
  private :parse_date 
end
