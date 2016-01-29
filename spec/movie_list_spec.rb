require_relative '../my_movies_list'
require_relative '../movie'
require_relative "../movies_list"
require_relative "../ancient_movie"
require_relative "../classic_movie"
require_relative "../modern_movie"
require_relative "../new_movie"
require 'csv'
require 'yaml'
require 'nokogiri'
require 'date'
require 'open-uri'
require 'webmock/rspec'
require 'vcr'


describe MyMoviesList do 
  
  before(:each) do
    @films = MyMoviesList.from_file("movies.txt","|")
  end

  it "checks five_longest function" do
    five_long_tmp = @films.movie_arr.sort_by{ |row| row.duration.to_i }.
      last(5).reverse
    @films.five_longest.should == five_long_tmp  
  end

  it "checks count_movie_in_month function" do
    tmp = @films.movie_arr.map{ |f| f.date }.compact.
      group_by{ |d| d.mon }.sort_by(&:first)
    @films.count_movie_in_month.should == tmp
  end
  
  it "checks select_by_genre function" do
    tmp = @films.movie_arr.sort_by(&:date).
      select{ |f| f.genre.include?("Drama") }
    @films.select_by_genre("Drama").should == tmp
  end

  it "checks all_directors function" do
    tmp = @films.movie_arr.map(&:author).uniq.
      sort_by{ |d| d.split(' ').last }
    @films.all_directors.should == tmp
  end

  it "checks rait_actors function" do
    tmp = @films.movie_arr.map(&:actors).
      flatten.sort.group_by(&:itself)
    @films.rait_actors.should == tmp
  end 

  it "checks sort_by_field function" do
    tmp = @films.movie_arr.sort_by(&:year)
    @films.sort_by_field("year").should == tmp
  end 

  it "checks sort_by_field function if passed not valid field" do
    lambda {@films.sort_by_field("abrvalg")}.should raise_error
  end 

  it "checks sorted_by function" do
    tmp = @films.movie_arr.sort_by{ |mov| [mov.year, mov.name] }
    @films.sorted_by{ |mov| [mov.year, mov.name] }.should == tmp
  end

  it "checks sort_by function" do
    tmp = @films.movie_arr.sort_by{ |mov| [mov.year, mov.name] }
    @films.add_sort_algo(:years_names){ |mov| [mov.year, mov.name] }
    @films.sort_by(:years_names).should == tmp
  end

  it "checks filter function" do
    tmp = @films.movie_arr.select{ |mov|  1990 <= mov.year && mov.year <= 2000 && 
      mov.has_genres?(['Comedy', 'Horror', 'Fantasy']) &&
      mov.point > 8.2 }
    @films.add_filter(:point_greater){|movie, gpoint| movie.point > gpoint}
    @films.add_filter(:genres){|movie, *genres| movie.has_genres?(genres)} 
    @films.add_filter(:years){|movie, from, to| (from..to).include?(movie.year)}
    @films.filter(
      genres: ['Comedy', 'Horror', 'Fantasy'],
      years: [1990, 2000],
      point_greater: 8.2).should == tmp
  end

  it "checks from_file function" do
    tmp = MyMoviesList.new( CSV.open("movies.txt", col_sep: "|").to_a.
      map{ |row| Movie.create(row) } )
    @films.movie_arr.should == tmp.movie_arr
  end

  it "checks load_from_yaml function" do
    tmp = YAML.load (File.open("xxx.yml"))
    @films.load_from_yaml("xxx.yml")
    @films.movie_arr.should == tmp
  end

  it "checks push_in_tmp_arr function" do
    tmp = Array.new
    MyMoviesList.send(:push_in_tmp_arr, "shoushenk.html", tmp)
    tmp[0].url.should == "shoushenk.html"
    tmp[0].name.should == "Побег из Шоушенка"
    tmp[0].year.should == 1994
    tmp[0].country.should == "USA"
    tmp[0].date.should == Date.strptime("1994-10-14", '%Y-%m-%d')
    tmp[0].genre.should == "Crime,Drama"
    tmp[0].duration.should == 142
    tmp[0].point.should == 9.0
    tmp[0].author.should == "Frank Darabont"
    tmp[0].actors.should == ["Tim Robbins", "Morgan Freeman", "Bob Gunton"]
  end

  it "checks from_imdb function to pass true url" do
    VCR.configure do |config|
      config.cassette_library_dir = "spec"
      config.hook_into :webmock 
    end
    VCR.use_cassette("page1") do
      MyMoviesList.from_imdb
    end
    WebMock.should have_requested(:get, 'http://www.imdb.com/chart/top')
  end

  it "checks from_imdb function to call push_in_tmp_arr func of 250 times" do
    VCR.configure do |config|
      config.cassette_library_dir = "spec"
      config.hook_into :webmock 
    end

    expect(MyMoviesList).to receive(:push_in_tmp_arr).exactly(250).times

    VCR.use_cassette("page1") do
      MyMoviesList.from_imdb
    end
    #expect(a_request(:get, %r{http://www\.imdb\.com/title.+})).
    #  to have_been_made.times(250)

  end

end
