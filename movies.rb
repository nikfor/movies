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
=end
if File.exist?(ARGV[0])
  fields = File.readlines( "movies.txt" )
  fields.map! { |e| e.chomp }
  fields.map! { |e|  e.split("|") }
  fields.each{ |i| puts i[1] + " " + "*" * i[7][2].to_i if i[1].include? "Time " }
else
  puts "File not found:" + ARGV[0]
end


