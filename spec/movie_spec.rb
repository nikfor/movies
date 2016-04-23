require 'rspec'
require 'date'
require_relative '../lib/movies/movie'
require_relative '../lib/movies/ancient_movie'
require_relative '../lib/movies/classic_movie'
require_relative '../lib/movies/modern_movie'
require_relative '../lib/movies/new_movie'


describe Movie do 
  
  let(:movie){ 
    Movie.create(["http://imdb.com",
        "The Shawshank Redemption",
        "1994",
        "USA",
        "1994-10-14",
        "Crime,Drama",
        "142 min",
        "9.3",
        "Frank Darabont",
        "Tim Robbins,Morgan Freeman,Bob Gunton"
    ])
  }
  let(:movie2){
    Movie.create(["http://imdb.com",
        "The Shawshank Redemption",
        "1940",
        "USA",
        "1940-10-14",
        "Crime,Drama",
        "142 min",
        "9.3",
        "Frank Darabont",
        "Tim Robbins,Morgan Freeman,Bob Gunton"
    ])
  }
  let(:movie3){
    Movie.create(["664564654",
        "The Shawshank Redemption",
        "1960",
        "USA",
        "1960-10-14",
        "Crime,Drama,Fantasy",
        "142 min",
        "9.3",
        "Frank Darabont",
        "Tim Robbins,Morgan Freeman,Bob Gunton"
    ])
  }
   

  describe :initialize do

    context "valid init year, date, duration, point, actors" do
      it { expect(movie.year).to eql(1994) }
      it { expect(movie.date).to eql(Date.strptime("1994-10-14", '%Y-%m-%d')) }
      it { expect(movie.duration).to eql(142) }
      it { expect(movie.point).to eql(9.3) }
      it { expect(movie.actors).to eql(["Tim Robbins", "Morgan Freeman", "Bob Gunton"])}

    end

    context "inclusion of a genre" do
      it{ expect(movie.has_genres?(["Drama", "Comedy"])).to be true }
      it{ expect(movie.has_genres?(["Drama", "Crime"])).to be true }
      it{ expect(movie.has_genres?(["Comedy", "Action"])).to be false }
    end
  end
  describe "equal movies" do
    it {expect(movie==movie2).to be true}
    it {expect(movie==movie3).to be false}
  end

  describe :method_missing do
    it {expect(movie.drama?).to be true}
    it {expect(movie.crime?).to be true}
    it {expect(movie.fantasy?).to be false}
  end

  describe :create do
    it {expect(movie.class).to be ModernMovie}
    it {expect(movie2.class).to be AncientMovie}
    it {expect(movie3.class).to be ClassicMovie}
  end

end

