=begin
good_movies =  [ 'Matrix', '300 Spartans', 'Dejavu', 'Spy games', 'Lucky number Slevin' ]
bad_movies = %w{ Titanic Hatico Witch }

all_str = ARGV[0]

if good_movies.include?(all_str)
  puts "#{all_str} is a good movie"
elsif bad_movies.include?(all_str)
  puts "#{all_str} is a bad movie"
else
  puts "Haven't seen #{all_str} yet"
end

unless File.exist?(ARGV[0])
  puts "File not found:" + ARGV[0]
  exit 0
end
fields = File.readlines( "movies.txt" )
fields.map! { |e| e.chomp }
fields.map! { |e|  e.split("|") }
fields.each{ |i| puts i[1] + " " + "*" * i[7][2].to_i if i[1].include? "Time " }


NAME_FIELDS = [:url, :name, :year, :country, :date, :genre, :duration, :point, :author, :actors]

films = File.readlines( "movies.txt" ).
  map { |ln| ln.chomp }.
  map { |ln|  Hash[*NAME_FIELDS.zip(ln.split("|")).flatten] }

# 3.2
puts "------------------------------------------------------------\nFive longest films:"
films.sort_by{ |f| f[:duration].to_i }.
  last(5).reverse.
  each{|f| puts "#{f[:name]} #{f[:genre]} #{f[:duration]}" }


# 3.3
puts "------------------------------------------------------------\nComedy films:"
films.sort_by{ |f| f[:date] }.
  select{ |f| f[:genre].include? "Comedy"}.
  each{|f| puts "#{f[:name]} #{f[:genre]} #{f[:duration]}" }

# 3.4
puts "------------------------------------------------------------\nAll directors alphabetically:"
films.map{ |ln| ln[:author].split(" ") }.
  uniq.sort_by{ |d| d.last }.
  each{ |d| 
    d.each{ |i| print "#{i} " }
    puts "\n"
  } 

# 3.5
puts "------------------------------------------------------------\nCount films shot not in the USA:"
puts films.reject{ |f| f[:country].include? "USA"}.count

# bonus 1

puts "------------------------------------------------------------\nGroup films by produce:"
films.group_by{ |f| f[:author]}.
  each{|auth, mov| 
    puts "#{auth} \n #{mov.map{ |m| m[:name]}.join("\n - ").insert(0, "- ")}"
  }                                              

# bonus 2
puts "------------------------------------------------------------\nHow many time was removed each actor:"
actors_arr = films.map{ |f| f[:actors].split(",")}.
  flatten.sort.group_by{ |a| a}.
  each{ |act, group| puts "#{act} - #{group.size}" }

=end

require 'csv'
require 'date'
require 'ostruct'

NAME_FIELDS = [:url, :name, :year, :country, :date, :genre, :duration, :point, :author, :actors]

films =  CSV.open("movies.txt", col_sep: "|").to_a.
  map{ |row| OpenStruct.new(Hash[*NAME_FIELDS.zip(row).flatten]) }  

#4

films.group_by{ |f| Date.strptime(f.date, '%Y-%m').mon if f.date.length >=7 }.
  delete_if{ |mon, group| mon == nil }.
  sort_by(&:first).
  each{ |mon_num, group| puts "#{Date::MONTHNAMES[mon_num]} - #{group.size} films" }

#3    
puts "------------------------------------------------------------\nFive longest films:"
films.sort_by(&:duration).
  last(5).reverse.
  each{|f| puts "#{f.name} #{f.genre} #{f.duration}" }


# 3.3
puts "------------------------------------------------------------\nComedy films:"
films.sort_by(&:date).
  select{ |f| f.genre.include? "Comedy"}.
  each{|f| puts "#{f.name} #{f.genre} #{f.duration}" }

# 3.4
puts "------------------------------------------------------------\nAll directors alphabetically:"
films.map(&:author).uniq.
  sort_by{ |d| d.split(' ').last }.
  each{ |d| puts d } 

# 3.5
puts "------------------------------------------------------------\nCount films shot not in the USA:"
puts films.reject{ |f| f.country.include? "USA"}.count

# bonus 1

puts "------------------------------------------------------------\nGroup films by produce:"
films.group_by(&:author).
  each{|auth, mov| 
    puts "#{auth} \n #{mov.map{ |m| m.name}.join("\n - ").insert(0, "- ")}"
  }                                              

# bonus 2
puts "------------------------------------------------------------\nHow many time was removed each actor:"
actors_arr = films.map{ |f| f.actors.split(",")}.
  flatten.sort.group_by(&:itself).
  each{ |act, group| puts "#{act} - #{group.size}" }


