require 'spec_helper'

describe TinySong do

  before(:each) do
    @api_key = 'TINYSONG_API_KEY'
  end

  it 'should have a version' do
    TinySong::VERSION.should_not be_nil
  end

  it 'should have a BASE_URL' do
    TinySong::BASE_URL.should == 'http://tinysong.com/'
  end

  describe 'first - /a/ -' do
    before(:each) do
      @search = 'Bad Brains'
      @search_url = URI.parse("http://tinysong.com/a/Bad+Brains?format=json&key=#{@api_key}")
      @response   = 'http://tinysong.com/gRqG'
    end

    it 'returns a single URL string' do
      Net::HTTP.should_receive(:get).once.with(@search_url).and_return(@response)
      @song_url = TinySong.first(@api_key, @search)
      @song_url.should == @response
    end
  end # first

  describe 'meta - /b/ -' do
    before(:each) do
      @search = 'Bad Brains'
      @search_url = URI.parse("http://tinysong.com/b/Bad+Brains?format=json&key=#{@api_key}")
      @response = '{"Url":"http://tinysong.com/gRqG","SongID":8417130,"SongName":"Banned in D.C.","ArtistID":3419,"ArtistName":"Bad Brains","AlbumID":255086,"AlbumName":"Bad Brains"}'
    end

    it 'returns meta information about the search' do
      Net::HTTP.should_receive(:get).once.with(@search_url).and_return(@response)
      @song_info = TinySong.meta(@api_key, @search)
      @song_info.should == JSON.parse(@response)
    end
  end # meta

  describe 'search - /s/ -' do
    before(:each) do
      @search = 'Bad Brains'
      @limit  = 3
      @search_url = URI.parse("http://tinysong.com/s/Bad+Brains?format=json&key=#{@api_key}&limit=#{@limit}")
      @response = '[{"Url":"http://tinysong.com/gRqG","SongID":8417130,"SongName":"Banned in D.C.","ArtistID":3419,"ArtistName":"Bad Brains","AlbumID":255086,"AlbumName":"Bad Brains"},{"Url":"http://tinysong.com/jM6e","SongID":7652154,"SongName":"Big Take Over","ArtistID":3419,"ArtistName":"Bad Brains","AlbumID":255086,"AlbumName":"Bad Brains"},{"Url":"http://tinysong.com/1vPh","SongID":506091,"SongName":"Attitude","ArtistID":3419,"ArtistName":"Bad Brains","AlbumID":255086,"AlbumName":"Bad Brains"}]'
    end

    it 'returns an array of search results' do
      Net::HTTP.should_receive(:get).once.with(@search_url).and_return(@response)
      @search_results = TinySong.search(@api_key, @search, @limit)
      @search_results.should == JSON.parse(@response)
    end
  end # search

end
