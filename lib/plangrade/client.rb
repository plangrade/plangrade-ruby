require 'plangrade/api'
require 'plangrade/configurable'
require 'plangrade/http_adapter'

module Plangrade
  class Client

    include Plangrade::Configurable
    include Plangrade::Api::User
    include Plangrade::Api::Company
    include Plangrade::Api::Participant

    attr_reader :site_url, :default_headers, :connection_options

    attr_accessor :client_id, :client_secret, :access_token

    def initialize(opts={})
      Plangrade::Configurable.keys.each do |key|
        case key
        when :headers, :connection_options
          value = Plangrade.instance_variable_get(:"@#{key}").merge(opts.fetch(key, {}))
        else
          value = opts.fetch(key, Plangrade.instance_variable_get(:"@#{key}"))
        end
        instance_variable_set(:"@#{key}", value)
      end
    end

    # makes a GET request
    def get(path, params={})
      request(:get, path, params)
    end

    # makes a PUT request
    def put(path, params={})
      request(:put, path, params)
    end

    # makes a POST request
    def post(path, params={})
      request(:post, path, params)
    end

    # makes a DELETE request
    def delete(path, params={})
      request(:delete, path, params)
    end

  private

    # returns an instance of the http adapter
    # if none is specified, the default is Plangrade::HttpConnection
    # @!visibility private
    def http_client
      @http_client ||= @http_adapter.new(@site_url, @connection_options)
    end

    # Makes an HTTP request using the provided parameters
    # @raise [Plangrade::Error::Unauthorized]
    # @param method [string]
    # @param path [string]
    # @param params [Hash]
    # @return [Plangrade::ApiResponse]
    # @!visibility private
    def request(method, path, params={})
      headers = @default_headers.merge({'Authorization' => "Bearer #{@access_token}"})
      result = http_client.send_request(method, path, {
        :params  => params,
        :headers => headers
      })
      result
    end
  end
end