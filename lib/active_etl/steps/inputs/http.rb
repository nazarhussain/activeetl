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
              data = get(options[:url], options[:data])
              @result = ActiveETL::Result.new(data)
              @result.type = ActiveETL::Result::TYPE_STRING
            when 'POST'
            when 'DELETE'
            else
              raise ArgumentError, "Option Method for value #{options[:method]} not supported by #{self.class}"
          end
          self
        end

        def default_options
          {url: nil, method: 'GET'.freeze, data: {}, user_agent: 'Active ETL HTTP Agent'.freeze}
        end

        def user_agent
          options[:user_agent]
        end
      end
    end
  end
end

