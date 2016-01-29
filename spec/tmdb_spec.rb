require_relative '../my_movies_list'
require_relative '../movie'
require_relative "../movies_list"


require 'date'
require 'open-uri'
require 'webmock/rspec'
require 'vcr'
require 'themoviedb-api'

describe MyMoviesList do

  it "checks receiving true url" do
    VCR.configure do |config|
      config.cassette_library_dir = "spec"
      config.hook_into :webmock 
    end

    VCR.use_cassette("page_tmdb") do
      MyMoviesList.from_tmdb
    end
    expect(WebMock).to  have_requested(:get, %r{http://api\.themoviedb\.org+}).times(161)
  end

  it "checks parse function" do
    VCR.configure do |config|
      config.cassette_library_dir = "spec"
      config.hook_into :webmock 
    end
    tmp = Array.new
    VCR.use_cassette("page_interstellar") do
      MyMoviesList.send(:get_movie_tmdb, 157336, tmp)
    end
    tmp[0].url.should == "https://interstellar.withgoogle.com/"
    tmp[0].name.should == "Interstellar"
    tmp[0].year.should == 2014
    tmp[0].country.should == "Canada,United States of America,United Kingdom"
    tmp[0].date.should == Date.strptime("2014-11-05", '%Y-%m-%d')
    tmp[0].genre.should == "Adventure,Drama,Science Fiction"
    tmp[0].duration.should == 169
    tmp[0].point.should == 8.2
    tmp[0].author.should == "Christopher Nolan"
    tmp[0].actors.should == ["Matthew McConaughey", "Anne Hathaway", "Jessica Chastain"]    
  end


  it "checks from_imdb function to call push_in_tmp_arr func of 40 times" do
    VCR.configure do |config|
      config.cassette_library_dir = "spec"
      config.hook_into :webmock 
    end
    expect(MyMoviesList).to receive(:get_movie_tmdb).exactly(40).times
    VCR.use_cassette("page_tmdb") do
      MyMoviesList.from_tmdb
    end
  end
  
end
