module Plangrade
  module ApiHandler

    def api_handler
      establish_api_handler
    end

    def establish_api_handler(opts={})
      Plangrade::Client.new(opts)
    end

  end
end