require 'cgi'
require 'json'
require 'net/http'
require 'uri'

module Grooveshark
  class TinySong

    VERSION  = '0.1.0'
    BASE_URL = 'http://tinysong.com/'

    # Class wrapper methods, which assume some defaults.
    class << self
      def first(query)
        new(query).first
      end

      def meta(query)
        new(query).meta
      end

      def search(query, *args)
        new(query).search(*args)
      end
    end # self

    def initialize(query, opts = {})
      @query  = CGI.escape(query)
      @format = (opts[:format] || opts['format']) || 'json'
    end

    # Returns a URL string with the first match of +query+ or nil.
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

    # Perform a search, returning +limit+ number of results (see #meta).
    # Minimum is 1; maximum is 32; default is 5.
    def search(limit = 5)
      @method = '/s/'
      @params = "&limit=#{limit}"
      @response = JSON.parse(send_request)
    end

    private

    # Returns the URI for the request method.
    def request
      # this is kinda hackish
      url_parts = [@method, @query, "?format=#{@format}"]
      url_parts << @params if @params
      URI.join(BASE_URL, url_parts.join)
    end

    # Fetches and returns the HTTP response (see #request).
    def send_request
      Net::HTTP.get(request)
    end

    # Remove any un-needed characters from +string+ (backslashes, quotes, etc.).
    # This is needed until the TinySong API is fixed to return a plain string.
    def sanitize_string(string)
      string.gsub!(/["]/, '')
      string.gsub!(/\\/, '')
      string
    end

  end # TinySong
end # Grooveshark
