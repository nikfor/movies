#!/usr/bin/env ruby
require 'optparse'
require_relative '../lib/movies/my_movies_list'

films = MyMoviesList.from_file("../files/movies.txt","|")
func = ''
#films.send(ARGV[0])


opts = OptionParser.new do |opts|
  opts.banner = "Movies: easy library for work with imdb-250 or tmdb-250"
  opts.separator ""
  opts.separator "Options:"

  opts.on("--type [TYPE]", [:create, :use]) do |v|
    films = {:create => MyMoviesList, :use => MyMoviesList.from_file("../files/movies.txt","|")}[v]
  end

  opts.on("-c command", "function") do |v|
    func = v
  end
end
opts.parse!

films.send(func)
