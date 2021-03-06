require 'csv'
require 'date'
require_relative 'movie' 

class MovieList
  
  attr_reader :movie_arr

  def initialize(path, separator)
    @movie_arr = CSV.open(path.to_s, col_sep: separator.to_s).to_a.
      map{ |row| Movie.new(*row) }
  end
    
  def count_movie_in_month
    #puts "------------------------------------------------------------\n\nCount movies in month:\n\n"
    @movie_arr.map{ |f| f.date }.compact.
      group_by(&:mon).sort_by(&:first)#.
      #each{ |mon_num, group| puts "#{Date::MONTHNAMES[mon_num]} - #{group.size} films" }
  end

  def five_longest
    #puts "------------------------------------------------------------\nFive longest films:"
    @movie_arr.sort_by(&:duration).
      last(5).reverse#.
      #each{|f| puts "#{f.name} #{f.genre} #{f.duration}" }
  end

  def select_by_genre(ingenre)
    raise ArgumentError, "Incorrect genre" unless @movie_arr.map { |movie| movie.genre.split(",") }.flatten.uniq.include?(ingenre)
    @movie_arr.sort_by(&:date).
      select{ |f| f.genre.include? ingenre}#.
      #each{|f| puts "#{f.name} #{f.genre} #{f.duration}" }
  end

  def all_directors
    #puts "------------------------------------------------------------\nAll directors alphabetically:"
    @movie_arr.map(&:author).uniq.
      sort_by{ |d| d.split(' ').last }#.
      #each{ |d| puts d } 
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
    #puts "------------------------------------------------------------\nHow many time was removed every actor:"
    @movie_arr.map(&:actors).
      flatten.sort.group_by(&:itself)#.
      #each{ |act, group| puts "#{act} - #{group.size}" }
  end

  def sort_by_field(field)
    raise ArgumentError, "Field name is not valid" if !Movie::FIELDS_FOR_SORT.include?(field)
    unit_meash = field == "duration" ? "min" : ""
    @movie_arr.sort_by{ |row| row.send field}#.      
      #each{ |row| puts "#{row.name} - #{row.send field} #{unit_meash}" }
  end

  def printt(&block)
    @movie_arr.each(&block)
  end

  def sorted_by 
    @movie_arr.sort_by{ |mov| yield(mov) }#.each{ |mov| puts "#{mov.year} #{mov.name} - #{mov.genre}" }
  end

  @@hsh_of_sorts = Hash.new{}

  def add_sort_algo(key_block, &block)
    @@hsh_of_sorts[key_block] = block 
  end

  def sort_by(key_block)
    raise ArgumentError, "Set sorting for key #{key_block}" if !@@hsh_of_sorts.has_key?(key_block) 
      @movie_arr.sort_by(&@@hsh_of_sorts[key_block])
        #each{ |mov| puts "#{mov.year} #{mov.name} - #{mov.genre}" }
  end

  @@hsh_of_filters = Hash.new{}

  def add_filter(key_filter, &block)
    @@hsh_of_filters[key_filter] = block
  end

  def filter(hsh_val)
    hsh_val.each_key{ |input_key| 
      raise ArgumentError,"Add the filter - #{input_key}" unless @@hsh_of_filters.map{ |key, val| key }.include?(input_key) }
    @movie_arr.select{ |mov|
      hsh_val.map{ |key, val| @@hsh_of_filters[key].call(mov, *val) }.all?
    }#.each{ |mov| puts "#{mov.name} - #{mov.year} - #{mov.point} - #{mov.genre} "}
  end

end
