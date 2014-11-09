module Plangrade
  module Resources
    class IdentityMap

      class InvalidKeyError < StandardError; end

      def initialize
        @map  = {}
        @size = 0
      end

      # @note retrives key from identity map
      # @return [Hash]
      # @param key [string] 
      # @param default [Hash]
      def get(key, default=nil)
        @map["#{key}"] || default
      end

      # @note inserts a hash of attributes into identity map
      # @return [Hash]
      # @param key [string] 
      # @param value [Hash]
      def put(key, value)
        if key.nil? || key.empty?
          raise InvalidKeyError.new
        end
        @map["#{key}"] = value
      end

      # @note returns the current size of identity map
      # @return [Integer]
      def size
        @map.keys.count
      end

      # clears the entire identity map
      # @return [Hash]
      def purge!
        @map = {}
      end
    end
  end
end