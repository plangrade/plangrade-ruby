module Plangrade
  class ApiResponse

    attr_reader :code, :headers

    def initialize(headers, body, code)
      @headers = headers
      @body    = body
      @code    = code.to_i
    end

    def raw_body
      @body
    end

    def body
      @parsed_body ||= parse(@body)
    end

    def empty?
      @body.nil? || @body.strip.empty?
    end

    def success?
      @code == 200
    end

    def created?
      @code == 201
    end

  private

    def parse(body)
      case body
      when /\A^\s*$\z/, nil
        nil
      else
        MultiJson.load(body, :symbolize_keys => true)
      end
    end
  end
end