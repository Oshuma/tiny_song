require 'cgi'
require 'net/http'
require 'uri'

module Grooveshark
  class TinySong

    VERSION  = '0.0.1'
    BASE_URL = 'http://tinysong.com/'

    class << self

      # Returns a URL string with the first match of +search+.
      #
      #   TinySong.first('Bad Brains')  # => "http://tinysong.com/2Z5Q"
      def first(search, format = 'json')
        search  = CGI.escape(search)
        request = URI.join(BASE_URL, '/a/', search, "?format=#{format}")
        sanitize_song_url(Net::HTTP.get(request))
      end

      private

      # Remove any un-needed characters from +url+ (backslashes, quotes, etc.).
      # This is needed until the TinySong API is fixed to return a plain string.
      def sanitize_song_url(url)
        url.gsub!(/["]/, '')
        url.gsub!(/\\/, '')
        url
      end

    end # self

  end # TinySong
end # Grooveshark
