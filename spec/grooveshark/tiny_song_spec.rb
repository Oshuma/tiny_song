require 'spec_helper'

describe TinySong do

  it 'should have a version' do
    TinySong::VERSION.should_not be_nil
  end

  it 'should have a BASE_URL' do
    TinySong::BASE_URL.should == 'http://tinysong.com/'
  end

  describe 'first - /a/ -' do
    before(:each) do
      @search = 'Bad Brains'
      @search_url = URI.parse('http://tinysong.com/a/Bad+Brains?format=json')
      @response   = 'http://tinysong.com/gRqG'
    end

    it 'returns a single URL string' do
      Net::HTTP.should_receive(:get).once.with(@search_url).and_return(@response)
      @song_url = TinySong.first(@search)
      @song_url.should == @response
    end
  end # first

  describe 'meta - /b/ -' do
    before(:each) do
      @search = 'Bad Brains'
      @search_url = URI.parse('http://tinysong.com/b/Bad+Brains?format=json')
      @response = '{"Url":"http://tinysong.com/gRqG","SongID":8417130,"SongName":"Banned in D.C.","ArtistID":3419,"ArtistName":"Bad Brains","AlbumID":255086,"AlbumName":"Bad Brains"}'
    end

    it 'returns meta information about the search' do
      Net::HTTP.should_receive(:get).once.with(@search_url).and_return(@response)
      @song_info = TinySong.meta(@search)
      @song_info.should == JSON.parse(@response)
    end
  end

end
