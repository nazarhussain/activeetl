require 'sawyer'

module ActiveETL
  module Steps
    module Inputs

      ##
      # Class to make calls to http endpoints
      # ==== Options
      # * +:url+        - URL to call
      # * +:methods+    - HTTP Verb GET, POST, DELETE
      # * +:user_agent+ - User Agent String to set
      # * +:data+       - Hash to data to post in case of POST sent in body, in case of GET sent in url
      #
      #
      class Http < ActiveETL::Steps::Base
        include ActiveETL::HttpAgent

        def process
          case options[:method]
            when 'GET'
              @result = ActiveETL::Result.new(get(options[:url], options[:params]), ActiveETL::Result::TYPE_BINARY)
            when 'POST'
            when 'DELETE'
            else
              raise ArgumentError, "Option Method for value #{options[:method]} not supported by #{self.class}"
          end
          self
        end

        def default_options
          {url: nil, method: 'GET'.freeze, params: {}, user_agent: 'Active ETL HTTP Agent'.freeze}
        end

        private
        # To be used by ActiveETL::HttpAgent
        def user_agent
          options[:user_agent]
        end
      end
    end
  end
end

