require_relative "plangrade/ruby/version"
require_relative "plangrade/error"
require_relative "plangrade/configurable"
require_relative "plangrade/api"
require_relative "plangrade/http_adapter"
require_relative "plangrade/oauth2_client"
require_relative "plangrade/client"
require_relative "plangrade/api_handler"
require_relative "plangrade/api_response"
require_relative "plangrade/resources"

module Plangrade
  class << self
  	include Configurable
  	include ApiHandler

  	def to_s
  	  "<#{self.name}: #{self.options.inspect}>"
  	end

  private
  	def method_missing(method_name, *args, &block)
  	  return super unless api_handler.respond_to?(method_name)
  	  api_handler.send(method_name, *args, &block)
  	end
  end
end

Plan = Plangrade

Plangrade.reset!