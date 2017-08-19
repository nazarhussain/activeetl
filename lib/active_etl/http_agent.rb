module ActiveETL
  module HttpAgent

    # Header keys that can be passed in options hash to {#get},{#head}
    CONVENIENCE_HEADERS = Set.new([:accept, :content_type])

    # Make a HTTP GET request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def get(url, options = {})
      request :get, url, parse_query_and_convenience_headers(options)
    end

    # Make a HTTP POST request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def post(url, options = {})
      request :post, url, options
    end

    # Make a HTTP PUT request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def put(url, options = {})
      request :put, url, options
    end

    # Make a HTTP PATCH request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Body and header params for request
    # @return [Sawyer::Resource]
    def patch(url, options = {})
      request :patch, url, options
    end

    # Make a HTTP DELETE request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def delete(url, options = {})
      request :delete, url, options
    end

    # Make a HTTP HEAD request
    #
    # @param url [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @return [Sawyer::Resource]
    def head(url, options = {})
      request :head, url, parse_query_and_convenience_headers(options)
    end

    # Hypermedia agent for the GitHub API
    #
    # @return [Sawyer::Agent]
    def agent
      @agent ||= Sawyer::Agent.new('', sawyer_options) do |http|
        http.headers[:user_agent] = user_agent
      end
    end

    # Fetch the root resource for the API
    #
    # @return [Sawyer::Resource]
    def root
      get '/'
    end

    # Response for last HTTP request
    #
    # @return [Sawyer::Response]
    def last_response
      @last_response if defined? @last_response
    end

    private

    def reset_agent
      @agent = nil
    end

    def request(method, path, data, options = {})

      if data.is_a?(Hash)
        options[:query]   = data.delete(:query) || {}
        options[:headers] = data.delete(:headers) || {}
        accept = data.delete(:accept)
        options[:headers][:accept] = accept if accept
      end

      options[:raw_body] = true

      @last_response = agent.call(method, URI::Parser.new.escape(path.to_s), data, options)
      @last_response.data
    end

    # Executes the request, checking if it was successful
    #
    # @return [Boolean] True on success, false otherwise
    def boolean_from_response(method, path, options = {})
      request(method, path, options)
      @last_response.status == 204
    rescue Octokit::NotFound
      false
    end

    def sawyer_options
      opts = {
          :links_parser => ::Sawyer::LinkParsers::Simple.new
      }
      opts[:faraday] = Faraday.new do |faraday|
        faraday.builder @middleware if @middleware
        faraday.proxy @proxy if @proxy
        faraday.adapter :excon, {persistent: true}

        # Changed in latest version of faraday
        # faraday.options = @connection_options || {}
      end
      opts
    end

    def parse_query_and_convenience_headers(options)
      headers = options.delete(:headers) { Hash.new }
      CONVENIENCE_HEADERS.each do |h|
        header = options.delete(h)
        headers[h] = header if header
      end
      query = options.delete(:query)
      opts = {:query => options}
      opts[:query].merge!(query) if query && query.is_a?(Hash)
      opts[:headers] = headers unless headers.empty?
      opts
    end
  end
end