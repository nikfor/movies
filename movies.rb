good_movies =  [ 'Matrix', '300 Spartans', 'Dejavu', 'Spy games', 'Lucky number Slevin' ]
bad_movies = %w{ Titanic Hatico Witch }

all_str = "hksdbfhbs" # не придумал ничего умнее :-|

ARGV.each do |wrd|
  if wrd == ARGV[0]
    all_str = wrd
  else
    all_str = all_str + ' ' + wrd
  end
end

if good_movies.include?(all_str)
  puts "#{all_str} is a good movie"
elsif bad_movies.include?(all_str)
  puts "#{all_str} is a bad movie"
else
  puts "Haven't seen #{all_str} yet"
end
  

