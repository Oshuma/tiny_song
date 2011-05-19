require 'cgi'
require 'json'
require 'net/http'
require 'uri'

module Grooveshark
  # TODO: Check for empty responses and return nil.
  class TinySong
    VERSION  = '0.2.0'

    # Base URL of the TinySong API.
    BASE_URL = 'http://tinysong.com/'

    # The requested search query.
    attr_reader :query

    class << self
      # Class wrapper method for TinySong#first.
      def first(api_key, query)
        new(api_key, query).first
      end

      # Class wrapper method for TinySong#meta.
      def meta(api_key, query)
        new(api_key, query).meta
      end

      # Class wrapper method for TinySong#search.
      def search(api_key, query, *args)
        new(api_key, query).search(*args)
      end
    end # self

    # Initialize a TinySong instance.
    #
    # [api_key] Get your TinySong API key here[http://tinysong.com/api].
    # [query] The search query passed to TinySong.
    def initialize(api_key, query, opts = {})
      @api_key = api_key
      @query   = CGI.escape(query)
      @format  = (opts[:format] || opts['format']) || 'json'
    end

    # Returns a URL string with the first match of the search query or nil.
    #
    #   TinySong.first(api_key, 'Bad Brains')
    #   # => "http://tinysong.com/2Z5Q"
    def first
      @method = '/a/'
      @response = send_request
      sanitize_string(@response)
    end

    # Returns a hash of meta information about the first song found or nil.
    #
    #   TinySong.meta(api_key, 'Bad Brains')
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

    # Perform a search, returning +limit+ number of results.
    # Minimum is 1; maximum is 32; default is 5.
    #
    #   TinySong.search(api_key, 'Bad Brains', 10)
    def search(limit = 5)
      @method = '/s/'
      @params = "&limit=#{limit}"
      @response = JSON.parse(send_request)
    end

    private

    # Returns the URI for the request method.
    # FIXME: Remove this URL param joining shit.
    def request
      url_parts = [@method, @query, "?format=#{@format}", "&key=#{@api_key}"]
      url_parts << @params if @params
      URI.join(BASE_URL, url_parts.join)
    end

    # Fetches and returns the HTTP response (see TinySong#request).
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
