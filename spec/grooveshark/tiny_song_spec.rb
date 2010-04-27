require 'spec_helper'

describe TinySong do

  it 'should have a version' do
    TinySong::VERSION.should_not be_nil
  end

  it 'should have a BASE_URL' do
    TinySong::BASE_URL.should == 'http://tinysong.com/'
  end

  describe 'first | /a/ -' do
    before(:each) do
      @search_string = 'Bad Brains'
      @search_url = URI.parse('http://tinysong.com/a/Bad+Brains?format=json')
      @response   = 'http://tinysong.com/gRqG'
    end

    it 'returns a single URL string' do
      Net::HTTP.should_receive(:get).with(@search_url).and_return(@response)
      @song_url = TinySong.first(@search_string)
      @song_url.should == @response
    end
  end

end
