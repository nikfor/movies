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
unless File.exist?(ARGV[0])
  puts "File not found:" + ARGV[0]
  exit 0
end
fields = File.readlines( "movies.txt" )
fields.map! { |e| e.chomp }
fields.map! { |e|  e.split("|") }
fields.each{ |i| puts i[1] + " " + "*" * i[7][2].to_i if i[1].include? "Time " }

# 3.1
fields.map! do |i|              
  { "url" => i[0], "name" => i[1], "year" => i[2], "country" => i[3], "date" => i[4], "genre" => i[5], "duration" => i[6], "point" => i[7], "author" => i[8], "actors" => i[9] }
end

# 3.2
sort = fields.sort_by do |i|    
  i["duration"].to_i
end
puts sort.reverse![0..4]


sort = fields.sort_by do |i|    # 3.3
  i["date"]
end
sort.delete_if do |i|
  !i["genre"].include? "Comedy"
end
puts sort

# 3.4
sort = fields.sort_by do |i|    
  i["author"]
end
a = []
sort.each {|i| a.push(i["author"])}

puts a.uniq!
                           

# 3.5

fields.delete_if do |i|
  i["country"].include? "USA"
end

puts fields.count


