require 'csv'
require 'date'
require 'set'
require_relative 'parse_date'

class Movie 
  
  include ParseDate

  @@weight_variable = 0.4
  @@print_frmt_str = ""

  FIELDS_FOR_SORT = ["url", "name", "year", "country", "date", "genre", "duration", "point", "author", "actors"]

  def self.weight (value)
    @@weight_variable = value
  end

  def weight
    @@weight_variable
  end

  def self.print_format (value)
    @@print_frmt_str = value
  end

  def self.print_frmt_out
    @@print_frmt_str
  end


  @@hsh_of_clssfilt = {}
  @@array_of_genres = Set.new

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
    @@array_of_genres.merge(genre.split(","))
  end


  def self.create(arr_f)
    @@hsh_of_clssfilt.detect { |key, val| val.call(arr_f[2].to_i) }[0].new(*arr_f)
  end

  def has_genres?(genres)
    !(genres & @genre.split(",")).empty?
  end

  def self.filter(&block)
    @@hsh_of_clssfilt[self] = block
  end

  def descriptionn
    tmp_hsh = { 
      :url => @url, 
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
    puts sprintf( self.class.print_frmt_out, tmp_hsh )
  end

  def method_missing (name, *args, &block)
    if @@array_of_genres.include?(name.to_s.chop.capitalize) && (name.to_s[-1] == "?") && (args.empty?)
      @genre.include?(name.to_s.chop.capitalize)
    else
      super  
    end
  end

  def ==(other)
    other.is_a?(Movie) && other.url == url
  end

  attr_reader :url, :name, :year, :country, :date, :genre, :duration, :point, :author, :actors
  attr_writer :point
  private :parse_date 
end
