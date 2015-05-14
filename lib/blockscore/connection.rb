require 'net/http'
require 'uri'
require 'active_support/core_ext/module/attribute_accessors'

module BlockScore
  module Connection
    ENDPOINT = 'https://api.blockscore.com'

    VERB_MAP = {
      :get    => Net::HTTP::Get,
      :post   => Net::HTTP::Post,
      :put    => Net::HTTP::Put,
      :delete => Net::HTTP::Delete
    }
    
    mattr_accessor :api_key, :http, :uri

    def self.included(mod)
      mod.uri ||= URI(ENDPOINT)
      mod.http ||= Net::HTTP.new(uri.host, uri.port)
      mod.http.use_ssl = true
    end

    def self.get(path, params)
      request :get, path, params
    end

    def self.post(path, params)
      request :post, path, params
    end

    def self.put(path, params)
      request :put, path, params
    end

    def self.delete(path, params)
      request :delete, path, params
    end

    private

    def self.request(method, path, params)
      case method
      when :get
        full_path = encode_path_params(path, params)
        request = VERB_MAP[method].new(full_path)
      else
        request = VERB_MAP[method].new(path)
        request.set_form_data(params)
      end

      # get api_key
      request.basic_auth(api_key, "")

      # set headers
      request['Accept'] = "application/vnd.blockscore+json;version=4"
      request['User-Agent'] = 'blockscore-ruby/4.1.0 (https://github.com/BlockScore/blockscore-ruby)'

      http.request(request)
    end

    def self.encode_path_params(path, params)
      encoded = URI.encode_www_form(params)
      [path, encoded].join("?")
    end
  end
end
