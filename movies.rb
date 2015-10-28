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
=end

films = File.readlines( "movies.txt" ).
  map { |ln| ln.chomp }.
  map { |ln|  ln.split("|") }.
  map { |f| { url: f[0], name: f[1], year: f[2], country: f[3], date: f[4], genre: f[5], duration: f[6], point: f[7], author: f[8], actors: f[9] }}


# 3.2

puts films.sort_by { |f| f[:duration].to_i }.last(5)


# 3.3

sort_films = films.sort_by do |f|    
  f[:date]
end
sort_films.delete_if do |f|
  !f[:genre].include? "Comedy"
end
puts sort_films
 

# 3.4

films.sort_by { |f| f[:author]}.
  map { |ln| ln[:author] }.uniq!.each{ |f| puts f}
        
                      
# 3.5

films.delete_if do |f|
  f[:country].include? "USA"
end

puts films.count


