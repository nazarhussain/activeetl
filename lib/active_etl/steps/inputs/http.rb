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
      # * +:params+       - Hash to data to post in case of POST sent in body, in case of GET sent in url
      #
      #
      class Http < ActiveETL::Steps::Base
        include ActiveETL::HttpAgent

        def process
          case options[:method]
            when 'GET'
              response = get(options[:url], options[:params])
            when 'POST'
            when 'DELETE'
            else
              raise ArgumentError, "Option Method for value #{options[:method]} not supported by #{self.class}"
          end

          @result = ActiveETL::Result.new(response,
                                          ActiveETL::Result::TYPE_BINARY, {
                                              status: last_response.status,
                                              headers: last_response.headers
                                          })
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

