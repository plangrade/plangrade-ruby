module Plangrade
  module Resources
    class Company < Plangrade::Resources::Base

      def self.create(ein, name)
        result = api_handler.create_company(:ein => ein, :name => name)
        return nil unless result.created?
        id = result.headers[:location].split('/').last.to_i
        new(:id => id)
      end

      attr_accessor_deffered :name, :ein, :grade

      def self.get(id)
        result = api_handler.get_company(id)
        return nil unless result.success?
        new(result.body[:company])
      end

      def self.all(opts={})
        result = api_handler.all_companies(opts)
        return nil unless result.success?
        new(result.body[:companies])
      end

      def update!(params)
        api_handler.update_company(@id, params)
      end
    end
  end
end