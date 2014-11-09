require 'plangrade/http_adapter'

module Plangrade
  module Configurable

    ENDPOINT = 'https://plangrade.com' unless defined? ENDPOINT
    HTTP_ADAPTER = Plangrade::HttpAdapter unless defined? HTTP_CONNECTION

    attr_accessor :client_id, :client_secret, :access_token, :site_url,
    :connection_options, :default_headers, :http_adapter

    # Return a hash with the default options
    # @return [Hash]
    def self.default_options
      {
        :site_url           => ENDPOINT,
        :client_id          => ENV['PLANGRADE_CLIENT_ID'],
        :client_secret      => ENV['PLANGRADE_CLIENT_SECRET'],
        :access_token       => ENV['PLANGRADE_ACCESS_TOKEN'],
        :http_adapter       => HTTP_ADAPTER,
        :connection_options => { :max_redirects => 5, :verify_ssl => true },
        :default_headers    => {
          'Accept'     => 'application/json',
          'User-Agent' => "Plangrade Ruby Gem #{Plangrade::Version}"
        }
      }
    end

    # @return [Array<String>]
    def self.keys
      self.default_options.keys
    end

    # @return [Hash]
    def options
      Hash[Plangrade::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

    def reset!
      Plangrade::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", Plangrade::Configurable.default_options[key.to_sym])
      end
      self
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self if block_given?
      self
    end

    def enable_logging(output='stdout')
      self.http_adapter.log = output
    end

    def disable_logging
      self.http_adapter.log = nil
    end

    def with_logging(output)
      cached_output = self.http_adapter.log
      enable_logging(output)
      yield self if block_given?
      self.http_adapter.log = cached_output
    end
  end
end