module Plangrade
  module Error

    class << self
      def from_status(status=nil)
        case status
        when 400
          BadRequest
        when 401
          Unauthorized
        when 403
          Forbidden
        when 404
          NotFound
        when 406
          NotAcceptable
        when 429
          RateLimitExceeded
        when 500
          InternalServerError
        when 502
          BadGateway
        when 503
          ServiceUnavailable
        else
          ApiError
        end
      end
    end

    # Raised when Plangrade returns unknown HTTP status code
    class ApiError < StandardError;  end

    # Raised when Plangrade returns the HTTP status code 400
    class BadRequest < ApiError; end

    # Raised when Plangrade returns the HTTP status code 401
    class Unauthorized < ApiError; end

    # Raised when Plangrade returns the HTTP status code 403
    class Forbidden < ApiError; end

    # Raised when Plangrade returns the HTTP status code 404
    class NotFound < ApiError; end

    # Raised when Plangrade returns the HTTP status code 406
    class NotAcceptable < ApiError; end

    # Raised when Plangrade returns the HTTP status code 429
    class RateLimitExceeded < ApiError; end

    # Raised when Plangrade returns the HTTP status code 500
    class InternalServerError < ApiError; end

    # Raised when Plangrade returns the HTTP status code 502
    class BadGateway < ApiError; end

    # Raised when Plangrade returns the HTTP status code 503
    class ServiceUnavailable < ApiError; end
  end
end