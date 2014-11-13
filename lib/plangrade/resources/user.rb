module Plangrade
  module Resources
    class User < Plangrade::Resources::Base

      def self.current_user
        result = api_handler.current_user
        new(result.body)
      end

      def self.create(email, name)
        result = api_handler.create_user(:email => email, :name => name)
        return nil unless result.created?
        id = result.headers[:location].split('/').last.to_i
        new(:id => id)
      end

      attr_accessor_deffered :email, :name

      def update!(params)
        api_handler.update_user(@id, params)
      end
    end
  end
end