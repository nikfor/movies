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
  
  let(:films){MyMoviesList.from_file("movies.txt","|")}

  describe :five_longest do
    subject{ films.five_longest }
    let(:expected){ films.movie_arr.sort_by(&:duration).last(5).reverse}
    it{ should == expected }    
  end

  describe :count_movie_in_month do
    subject{ films.count_movie_in_month }
    let(:expected){ films.movie_arr.map(&:date).compact.group_by(&:mon).sort_by(&:first)  }
    it{should == expected}
  end

  describe :select_by_genre do
    subject{ films.select_by_genre("Drama") }
    let(:expected){ films.movie_arr.sort_by(&:date).
      select{ |f| f.genre.include?("Drama") } 
    }
    it{ should == expected }
  end

  describe :all_directors do
    subject{ films.all_directors }
    let(:expected){ films.movie_arr.map(&:author).uniq.
      sort_by{ |d| d.split(' ').last }
    }
    it{ should == expected }
  end

  describe :rait_actors do
    subject{ films.rait_actors }
    let(:expected){ films.movie_arr.map(&:actors).
      flatten.sort.group_by(&:itself) 
    }
    it{ should == expected }
  end

  describe :sort_by_field do
    context 'if passed valid field' do
      subject{ films.sort_by_field("year") }
      let(:expected){ films.movie_arr.sort_by(&:year) }
      it{ should == expected }
    end

    context 'if passed not valid field' do
      subject{ lambda{films.sort_by_field("abrvalg")} }
      it{ should raise_error(ArgumentError) }
    end
  end

  describe :sorted_by do
    subject{ films.sorted_by{ |mov| [mov.year, mov.name] } }
    let(:expected){ films.movie_arr.sort_by{ |mov| [mov.year, mov.name] } }
    it{ should == expected }
  end

  describe :sort_by do
    context "if a key for sorting the correct" do
      subject do 
        films.add_sort_algo(:years_names){ |mov| [mov.year, mov.name] }
        films.sort_by(:years_names)
      end
      let(:expected){ films.movie_arr.sort_by{ |mov| [mov.year, mov.name]} }
      it{ should == expected }
    end
    context "if a key for sorting isn't correct" do
      subject{lambda{ films.sort_by(:abrvalg) }}
      it{ should raise_error(ArgumentError)}
    end
  end

  describe :filter do
    before(:each) do
      films.add_filter(:point_greater){|movie, gpoint| movie.point > gpoint}
      films.add_filter(:genres){|movie, *genres| movie.has_genres?(genres)} 
      films.add_filter(:years){|movie, from, to| (from..to).include?(movie.year)}
    end
    context 'if pass all filters' do
      subject do
        films.filter(
          genres: ['Comedy', 'Horror', 'Fantasy'],
          years: [1990, 2000],
          point_greater: 8.2)
      end
      let(:expected) do
        films.movie_arr.select{ |mov|  1990 <= mov.year && mov.year <= 2000 && 
          mov.has_genres?(['Comedy', 'Horror', 'Fantasy']) &&
          mov.point > 8.2 
        }
      end
      it{ should == expected }
    end
    context 'if pass not valid filter key' do
      it { expect{films.filter(
            genres: ['Comedy', 'Horror', 'Fantasy'],
            qwerty: [1990, 2000],
            point_greater: 8.2)}.to raise_error(ArgumentError)
      }
    end
    context 'if pass part of all filters' do
      subject do
        films.filter(
          years: [1990, 2000],
          point_greater: 8.2)
      end
      let(:expected) do
        films.movie_arr.select{ |mov|  1990 <= mov.year && mov.year <= 2000 && 
          mov.point > 8.2 
        }
      end
      it{ should == expected }
    end
    context 'if pass not crossed filters' do
      subject do
        films.filter(
          genres: ['Comedy', 'Horror', 'Fantasy'],
          years: [1990, 1994],
          point_greater: 8.2)
      end
      it{ should == [] }
    end
  end

  describe :from_file do
    context "if file exist" do
      subject{ MyMoviesList.from_file("movies.txt","|").movie_arr }
      let(:expected) do
        MyMoviesList.new( CSV.open("movies.txt", col_sep: "|").to_a.
        map{ |row| Movie.create(row) } ).movie_arr
      end
      it{ should == expected}
    end
    context "if file don't exist" do
      it { expect{MyMoviesList.from_file("abrvalg.txt","|")}.
        to raise_error(Errno::ENOENT) }
    end
  end
  
  describe :load_from_yaml do
    context "if file exist" do
      subject{ films.load_from_yaml("xxx.yml")
               films.movie_arr }
      let(:expected){ YAML.load(File.open("xxx.yml")) }
      it{ should == expected }
    end
    context "if file don't exist" do
      it { expect{films.load_from_yaml("abrvalg.yml")}.
        to raise_error(Errno::ENOENT) }
    end
  end

  describe :get_movie_imdb do
    subject{  MyMoviesList.send(:get_movie_imdb, "shoushenk.html") }
    expected = [ "shoushenk.html", 
      "Побег из Шоушенка", 
      "1994", 
      "USA", 
      "1994-10-14",
      "Crime,Drama",
      "142 min",
      "9,3",
      "Frank Darabont",
      "Tim Robbins,Morgan Freeman,Bob Gunton"
    ]
    it{ should == expected }
  end

  it "should pass true url" do
    VCR.configure do |config|
      config.cassette_library_dir = "spec"
      config.hook_into :webmock 
    end

    VCR.use_cassette("page1") do
      MyMoviesList.from_imdb
    end
    WebMock.should have_requested(:get, 'http://www.imdb.com/chart/top')
  end

  it "should call get_movie_imdb func of 250 times" do
    VCR.configure do |config|
      config.cassette_library_dir = "spec"
      config.hook_into :webmock 
    end
    #expect(MyMoviesList).to receive(:get_movie_imdb).exactly(250).times
    VCR.use_cassette("page1") do
      MyMoviesList.from_imdb
    end
    expect(a_request(:get, %r{http://www\.imdb\.com/title.+})).
     to have_been_made.times(250)
  end

end
