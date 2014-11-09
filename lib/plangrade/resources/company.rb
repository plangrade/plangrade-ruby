module Plangrade
  class Resources
    class Company < Plangrade::Resources::Base

      def self.create(ein, name)
        result = api_handler.create_company(:ein => ein, :name => name)
        return nil unless result.created?
        id = result.headers[:location].split('/').last.to_i
        new(:id => id)
      end

      attr_accessor_deffered :id, :name, :ein, :grade

      def update!(params)
        api_handler.update_company(@id, params)
      end
    end
  end
end