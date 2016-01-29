require 'rspec'
require_relative '../movie'

describe Movie do 
  
  it "checks for inclusion of a genre" do
    mov = Movie.new("http://imdb.com",
                    "The Shawshank Redemption",
                    "1994",
                    "USA",
                    "1994-10-14",
                    "Crime,Drama",
                    "142 min",
                    "9.3",
                    "Frank Darabont",
                    "Tim Robbins,Morgan Freeman,Bob Gunton")
    mov.has_genres?(["Drama", "Comedy"]).should == true
    mov.has_genres?(["Drama", "Crime"]).should == true
    mov.has_genres?(["Comedy", "Action"]).should == false
  end

end

