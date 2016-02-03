require_relative '../my_movies_list'
require_relative '../movie'
require_relative "../movies_list"


require 'date'
require 'open-uri'
require 'webmock/rspec'
require 'vcr'
require 'themoviedb-api'

describe MyMoviesList do

  before(:each) do
    VCR.configure do |config|
      config.cassette_library_dir = "spec"
      config.hook_into :webmock 
    end
  end

  it "receive true url" do
    VCR.use_cassette("page_tmdb") do
      MyMoviesList.from_tmdb
    end
    expect(WebMock).to  have_requested(:get, %r{http://api\.themoviedb\.org+}).times(161)
  end

  describe :get_movie_tmdb do
    subject{
      VCR.use_cassette("page_interstellar") do
         MyMoviesList.send(:get_movie_tmdb, 157336) 
      end
    }
    expected = ["https://interstellar.withgoogle.com/",
    "Interstellar",
    "2014",
    "Canada,United States of America,United Kingdom",
    "2014-11-05",
    "Adventure,Drama,Science Fiction",
    169,
    8.2,
    "Christopher Nolan",
    "Matthew McConaughey,Anne Hathaway,Jessica Chastain"]
    it { should == expected }
  end


  it "call get_movie_tmdb func of 40 times" do
    MyMoviesList.should_receive(:get_movie_tmdb).exactly(40).times.and_call_original
    VCR.use_cassette("page_tmdb") do
      MyMoviesList.from_tmdb
    end
  end
  
end
