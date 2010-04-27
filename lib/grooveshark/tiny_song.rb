require 'cgi'
require 'json'
require 'net/http'
require 'uri'

module Grooveshark
  class TinySong

    VERSION  = '0.0.1'
    BASE_URL = 'http://tinysong.com/'

    # Class wrapper methods, which assume some defaults.
    class << self
      def first(search)
        new(search).first
      end

      def meta(search)
        new(search).meta
      end
    end # self

    def initialize(search, opts = {})
      @search = CGI.escape(search)
      @format = (opts[:format] || opts['format']) || 'json'
    end

    # Returns a URL string with the first match of +search+ or nil.
    #
    #   TinySong.first('Bad Brains')  # => "http://tinysong.com/2Z5Q"
    def first
      @method = '/a/'
      @response = send_request
      sanitize_string(@response)
    end

    # Returns a hash of meta information about the #first song found or nil.
    #
    #   TinySong.meta('Bad Brains')
    #   # => {
    #     "Url" => "http://tinysong.com/2Z5Q",
    #     "SongID" => 8417130,
    #     "SongName" => "Banned in D.C.",
    #     "ArtistID" => 3419,
    #     "ArtistName" => "Bad Brains",
    #     "AlbumID" => 255086,
    #     "AlbumName" => "Bad Brains"
    #   }
    def meta
      @method = '/b/'
      @response = JSON.parse(send_request)
      @response['Url'] = sanitize_string(@response['Url']) if @response['Url']
      @response
    end

    private

    # Returns the URI for the request method.
    def request
      URI.join(BASE_URL, @method, @search, "?format=#{@format}")
    end

    # Fetches and returns the HTTP response (see #request).
    def send_request
      Net::HTTP.get(request)
    end

    # Remove any un-needed characters from +response_string+ (backslashes, quotes, etc.).
    # This is needed until the TinySong API is fixed to return a plain string.
    def sanitize_string(string)
      string.gsub!(/["]/, '')
      string.gsub!(/\\/, '')
      string
    end

  end # TinySong
end # Grooveshark
